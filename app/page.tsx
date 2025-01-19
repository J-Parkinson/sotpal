'use client';

import { MainLogo } from '@/components/logo/logo';
import React from 'react';
import Button from '@/components/button/button';

export const runtime = 'edge';
export const preferredRegion = 'home';
export const dynamic = 'force-dynamic';

export default function Home() {
  return (
    <main className="relative flex min-h-screen flex-col items-center justify-center gap-10">
      <MainLogo />
      <div className="p-5 flex flex-col items-center justify-center gap-5">
        <Button onClick={() => {}}>Start Game</Button>
        <Button onClick={() => {}}>Join Game</Button>
      </div>
    </main>
  );
}
