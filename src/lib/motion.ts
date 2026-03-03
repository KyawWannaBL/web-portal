export const springPresets = {
  gentle: { type: "spring" as const, stiffness: 100, damping: 20 },
  slow: { type: "spring" as const, stiffness: 50, damping: 20 },
  stiff: { type: "spring" as const, stiffness: 200, damping: 20 },
};
export const fadeInUp = { hidden: { opacity: 0, y: 20 }, visible: { opacity: 1, y: 0, transition: { duration: 0.5 } } } as any;
export const staggerContainer = { hidden: { opacity: 0 }, visible: { opacity: 1, transition: { staggerChildren: 0.1 } } } as any;
export const staggerItem = { hidden: { opacity: 0, y: 20 }, visible: { opacity: 1, y: 0 } } as any;
export const hoverLift = { whileHover: { y: -5, transition: { duration: 0.2 } } } as any;
