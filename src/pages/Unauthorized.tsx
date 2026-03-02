export default function Unauthorized() {
  return (
    <div className="min-h-screen flex items-center justify-center p-8">
      <div className="max-w-md text-center">
        <h1 className="text-xl font-black">Unauthorized</h1>
        <p className="mt-2 text-sm opacity-70">You don’t have permission to access this area.</p>
      </div>
    </div>
  );
}
