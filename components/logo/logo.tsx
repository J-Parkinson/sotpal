'use client'

import logo from "./logo.module.css";
import AnimationWrapper from "@/components/styles/animation-wrapper";

const Logo = ({ text }: { text: string }) => {
    return <h1 className={logo.Logo}>{text}</h1>;
};

export const MainLogo = () => <AnimationWrapper>
    <div className={logo.MainLogo}>
        <Logo text="SOME OF THESE"/><Logo text="PEOPLE ARE LYING"/>
    </div>
</AnimationWrapper>;

export default Logo;