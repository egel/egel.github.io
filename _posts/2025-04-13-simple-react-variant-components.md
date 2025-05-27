---
layout: post
title: Simply best React variant components
published: true
tags: [react, tailwind, typescript]
# feature-img: "assets/img/feature/pexels-fatih-turan-63325184-8777703.jpg"
---

At the moment on the market there is lot to not say too much different ways to build components. Each company or individual is speeding another to craft better and more robust library, framework, or something that is between these to.

I recently have pleasure to more work on react and tailwind. This is enjoyable combo although I am still not sure if tailwind is something great. What is does quite good is to organize a default workflow with styles elements (CSS) and give it wraps it under nice documentation with search. So as you can see it's just organized CSS within classes, that are nicely sold with in tailwind package.

I am mentioning about tailwind (as still being) biased as the lately was looking for a nice way to craft some react components in variants. I wanted to find a nice declarative way to build few styles of some component and expose them under `variant` (or `variation`) property, so the user can select how the component should look like but without lot of creating few components and still share core styles.

In thins mix I used 3 ingredients: `react`, `tailwind` and `cn` method[^cn].

With this we can build simple and reusable variants of react components. Let's take simple react button component.

> PS I am a fan of building components that does one thing, one thing only but very good. So there should be no one component for everything with 20 variants. I think there should be 3-4 components and each one persist it's unique functionality with nice visual variants. The interface of those components will be much smaller and better to orientate by people who use them - and also easy to replace when needed.

For example if we are building a nice website at some point we need `Button`s to add some interaction.

I can thing of 2 simple buttons:

-   regular round buttons (meant for regular actions, like forms clicks)
-   CTA[^cta] buttons that are meant tp drain bit more user attention

Let's consider regular button and what kind of interface we would like to have?

```ts
<Button variant="primary" size="md" ... />
```

For demonstration purpose I omit all other button props and focus on visual interface. As we can see this is quite simple and pleasant interface that should answer most of our needs from the styling.

-   With `variant` option we could add anything that make sense for our Design Style Guide (e.g. primary, secondary, default, success, danger, warning, info, etc.)
-   size may hold different available sizes (like: xs, sm, md, lg, ect.)

Now shall we dive how to build it that make sense? I will add complete example below

```ts
import { forwardRef, HTMLAttributes, ReactElement } from "react";

export const ButtonVariant = {
    primary: "primary",
    secondary: "secondary",

    danger: "danger",
    success: "success",
    warning: "warning",
    info: "info",
};
export type ButtonVariant = (typeof ButtonVariant)[keyof typeof ButtonVariant];

export const ButtonSize = {
    xs: "xs",
    sm: "sm",
    md: "md",
    lg: "lg",
};
export type ButtonSize = (typeof ButtonSize)[keyof typeof ButtonSize];

export interface ButtonProps extends HTMLAttributes<HTMLButtonElement> {
    /**
     * Variation of component look
     */
    variation: ButtonVariant;

    /**
     * Size of component
     */
    size: ButtonSize;

    /**
     * Custom className(s) list assigned to root's element
     */
    className?: string;
}

const elementClassId = "app-button-cta"; // best for later debug purpose
const Button = forwardRef<HTMLButtonElement, ButtonProps>(
    (
        { children, className: externalClasses, rel = "noopener noreferrer", ...otherProps },
        ref
    ): ReactElement => {
        const stylesButtonCommon = cn(
            "flex items-center justify-center",
            "font-medium text-sm sm:text-base h-10 sm:h-12 px-4 sm:px-5 sm:w-auto",
            "rounded-full border border-solid border-transparent transition-colors",
            "hover:cursor-pointer",
            "bg-foreground text-background gap-2"
        );

        const styleButtonPrimary = cn("hover:bg-[#383838] dark:hover:bg-[#ccc]");

        const stylesRoot = cn(
            elementClassId,
            stylesButtonCommon,
            {
                [styleButtonPrimary]: variation === ButtonCTAVariation.primary,
            },
            externalClasses
        );

        const stylesRoot = cn(
            elementClassId,
            "inline-flex select-none items-center justify-center rounded-md px-4 py-2 text-sm font-medium",
            "bg-white text-gray-700 hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-100 dark:hover:bg-gray-900",
            "hover:bg-gray-50",
            "focus:outline-hidden focus-visible:ring-3 focus-visible:ring-purple-500 focus-visible:ring-opacity-75",
            // Register all radix states
            "group",
            "radix-state-open:bg-gray-50 dark:radix-state-open:bg-gray-900",
            "radix-state-on:bg-gray-50 dark:radix-state-on:bg-gray-900",
            "radix-state-instant-open:bg-gray-50 dark:radix-state-instant-open:bg-gray-900",
            "radix-state-delayed-open:bg-gray-50 dark:radix-state-delayed-open:bg-gray-900",
            externalClasses
        );

        // RENDER
        return (
            <button ref={ref} className={stylesRoot} rel={rel} {...otherProps}>
                {children}
            </button>
        );
    }
);
Button.displayName = "button";

export default Button;
```

[^cn]: aka `classname`. method that merges tailwind classnames and provide additional conditional functionality.
[^cta]: Call To Action
