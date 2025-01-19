'use client'

import {FC, ReactElement, useEffect, useState} from "react";
import animation from "./mount-animate.module.css"
import classNames from "classnames";

export interface AnimationWrapperProps {
    children: ReactElement;
}

const AnimationWrapper: FC<AnimationWrapperProps> = ({children}) => {
    const [isMounted, setIsMounted] = useState(true);

    useEffect(() => {
        setIsMounted(true);
        return () => setIsMounted(false); // Cleanup on unmount
    }, []);

    return <div className={classNames({[animation.OnMount]: isMounted, [animation.OnUnmount]: !isMounted})}>
        {children}
    </div>
};

export default AnimationWrapper;