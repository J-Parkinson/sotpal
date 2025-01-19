import './globals.css'
import { Anton } from 'next/font/google'
import React from "react";

export const metadata = {
  metadataBase: new URL('https://sotpal.vercel.app'),
  title: 'Some of these People are Lying',
  description:
    'A website that implements the "Technical Difficulties" game "Two of these People Are Lying", with support for more people.',
}

const anton = Anton({
  variable: '--font-anton',
  subsets: ['latin'],
  display: 'swap',
  weight: "400",
})

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={anton.variable}>{children}</body>
    </html>
  )
}
