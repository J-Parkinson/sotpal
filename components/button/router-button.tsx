'use client';

import React, { FC, ReactNode } from "react";
import { useRouter } from 'next/navigation';
import { useTransition } from 'react';
import styles from "./button.module.css";
import Button from "@/components/button/button";

interface RouterButtonProps {
    children: ReactNode;
    href: string;
}

const RouterButton: FC<RouterButtonProps> = ({ children, href }) => {
    const router = useRouter();
    const [isPending, startTransition] = useTransition();

    return (
        <Button
            className={`${styles.Button} ${isPending ? 'cursor-not-allowed' : ''}`}
            disabled={isPending}
            onClick={() => {
                startTransition(() => {
                    router.push(href);
                });
            }}
        >
            {isPending ? 'Loading...' : children}
        </Button>
    );

};

export default RouterButton;

