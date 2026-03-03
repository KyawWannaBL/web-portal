import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const REPORT_DIR = path.resolve("reports");
const RAW_LOG = path.join(REPORT_DIR, "full-build-raw.log");
const JSON_OUT = path.join(REPORT_DIR, "full-build-report.json");
const TXT_OUT = path.join(REPORT_DIR, "full-build-missing.txt");

function uniqSort(arr) {
  return Array.from(new Set(arr)).sort((a, b) => a.localeCompare(b));
}

function classifyModule(mod) {
  if (mod.startsWith("@/") || mod.startsWith("./") || mod.startsWith("../") || mod.startsWith("/")) return "local";
  return "external";
}

function parseMissingModules(log) {
  const missing = [];

  // TS2307: Cannot find module '...'
  for (const m of log.matchAll(/TS2307:\s+Cannot find module ['"]([^'"]+)['"]/g)) {
    missing.push(m[1]);
  }

  // TS2688: Cannot find type definition file for '...'
  for (const m of log.matchAll(/TS2688:\s+Cannot find type definition file for ['"]([^'"]+)['"]/g)) {
    missing.push(`@types/${m[1]}`);
  }

  return missing;
}

async function run() {
  fs.mkdirSync(REPORT_DIR, { recursive: true });

  const cmd = process.platform === "win32" ? "npx.cmd" : "npx";
  const args = ["tsc", "-b", "--pretty", "false"];

  const child = spawn(cmd, args, { stdio: ["ignore", "pipe", "pipe"] });

  let out = "";
  child.stdout.on("data", (d) => (out += d.toString()));
  child.stderr.on("data", (d) => (out += d.toString()));

  const exitCode = await new Promise((resolve) => child.on("close", resolve));

  fs.writeFileSync(RAW_LOG, out, "utf8");

  const missingAll = parseMissingModules(out);
  const localMissing = uniqSort(missingAll.filter((m) => classifyModule(m) === "local"));
  const externalMissing = uniqSort(missingAll.filter((m) => classifyModule(m) === "external"));

  const result = {
    generatedAt: new Date().toISOString(),
    exitCode,
    missing: {
      local: localMissing,
      external: externalMissing,
      total: localMissing.length + externalMissing.length,
    },
    notes: {
      rawLog: path.relative(process.cwd(), RAW_LOG),
      howToFix:
        "Local modules (@/*, ./, ../) usually mean files are missing or path casing differs. External modules mean npm packages missing (npm i <pkg>).",
    },
  };

  fs.writeFileSync(JSON_OUT, JSON.stringify(result, null, 2) + "\n", "utf8");

  const lines = [
    `Exit code: ${exitCode}`,
    "",
    `Missing external modules (${externalMissing.length}):`,
    ...externalMissing.map((m) => `  - ${m}`),
    "",
    `Missing local modules (${localMissing.length}):`,
    ...localMissing.map((m) => `  - ${m}`),
    "",
    `Raw log: ${path.relative(process.cwd(), RAW_LOG)}`,
    `JSON report: ${path.relative(process.cwd(), JSON_OUT)}`,
  ];

  fs.writeFileSync(TXT_OUT, lines.join("\n") + "\n", "utf8");

  console.log(`Wrote:\n- ${path.relative(process.cwd(), TXT_OUT)}\n- ${path.relative(process.cwd(), JSON_OUT)}\n`);

  process.exit(typeof exitCode === "number" ? exitCode : 1);
}

run().catch((e) => {
  console.error(e);
  process.exit(1);
});
