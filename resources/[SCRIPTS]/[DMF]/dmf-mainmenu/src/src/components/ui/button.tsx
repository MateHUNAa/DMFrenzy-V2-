"use client"

import type React from "react"

import { forwardRef } from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"
import { Loader2 } from "lucide-react"

const buttonVariants = cva(
  "relative inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default:
          "bg-gradient-to-r from-cyan-500 to-cyan-600 text-cyan-950 shadow-md hover:from-cyan-600 hover:to-cyan-700 active:from-cyan-700 active:to-cyan-800 focus-visible:ring-cyan-500",
        destructive:
          "bg-gradient-to-r from-rose-500 to-rose-600 text-white shadow-md hover:from-rose-600 hover:to-rose-700 active:from-rose-700 active:to-rose-800 focus-visible:ring-rose-500",
        outline:
          "border border-zinc-700 bg-zinc-800/50 text-zinc-100 backdrop-blur-sm hover:bg-zinc-800 hover:text-white focus-visible:ring-zinc-500",
        secondary:
          "bg-gradient-to-r from-zinc-700 to-zinc-800 text-zinc-100 shadow-md hover:from-zinc-600 hover:to-zinc-700 active:from-zinc-800 active:to-zinc-900 focus-visible:ring-zinc-500",
        ghost: "text-zinc-300 hover:bg-zinc-800 hover:text-white focus-visible:ring-zinc-500",
        link: "text-cyan-400 underline-offset-4 hover:underline focus-visible:ring-cyan-500",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-8 rounded-md px-3 text-xs",
        lg: "h-12 rounded-md px-6 text-base",
        icon: "h-10 w-10",
      },
      glow: {
        true: "after:absolute after:inset-0 after:rounded-md after:opacity-40 after:blur-md after:transition-opacity hover:after:opacity-60",
        false: "",
      },
    },
    compoundVariants: [
      {
        variant: "default",
        glow: true,
        className: "after:bg-cyan-500/50",
      },
      {
        variant: "destructive",
        glow: true,
        className: "after:bg-rose-500/50",
      },
    ],
    defaultVariants: {
      variant: "default",
      size: "default",
      glow: false,
    },
  },
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  isLoading?: boolean
  leftIcon?: React.ReactNode
  rightIcon?: React.ReactNode
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, glow, isLoading, leftIcon, rightIcon, children, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, glow, className }))}
        ref={ref}
        disabled={isLoading || props.disabled}
        {...props}
      >
        {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {!isLoading && leftIcon && <span className="mr-2">{leftIcon}</span>}
        {children}
        {rightIcon && <span className="ml-2">{rightIcon}</span>}
      </button>
    )
  },
)
Button.displayName = "DMF Button"

export { Button, buttonVariants }