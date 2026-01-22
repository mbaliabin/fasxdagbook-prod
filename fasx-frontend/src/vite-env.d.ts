/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL?: string;
  readonly [key: string]: string | undefined;
}

// Augment the global ImportMeta interface
interface ImportMeta {
  readonly env: ImportMetaEnv;
}

