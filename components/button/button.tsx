'use client'

import React, {FC, ReactNode} from "react";
import styles from "./button.module.css";
import classNames from "classnames";

interface ButtonProps {
    children: ReactNode;
    onClick: () => void;
    className?: string;
    disabled?: boolean;
}

const Button: FC<ButtonProps> = ({ children, onClick, className, disabled }) => {
    return (
        <button className={classNames(styles.Button, className, {[styles.DisabledButton]: disabled})} onClick={() => !disabled && onClick()}>
            {children}
        </button>
    );
};

export default Button;
