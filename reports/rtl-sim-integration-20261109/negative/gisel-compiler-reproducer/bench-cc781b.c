# 1 "<built-in>"
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#if defined(__CLANG_REWRITTEN_INCLUDES) /* bench.h expanded by -frewrite-includes */
#include "bench.h"
#else /* bench.h expanded by -frewrite-includes */
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h" 1
#ifndef LIB_BENCH_BENCH_H
#define LIB_BENCH_BENCH_H

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stdint.h expanded by -frewrite-includes */
#include <stdint.h>
#else /* stdint.h expanded by -frewrite-includes */
# 4 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 1 3
/*===---- stdint.h - Standard header for sized integer types --------------===*\
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
\*===----------------------------------------------------------------------===*/

#ifndef __CLANG_STDINT_H
// AIX system headers need stdint.h to be re-enterable while _STD_TYPES_T
// is defined until an inclusion of it without _STD_TYPES_T occurs, in which
// case the header guard macro is defined.
#if 0 /* disabled by -frewrite-includes */
#if !defined(_AIX) || !defined(_STD_TYPES_T) || !defined(__STDC_HOSTED__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#define __CLANG_STDINT_H
#endif
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stdint.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stdint.h>
#endif /* expanded by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# 19 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#else
# 20 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* If we're hosted, fall back to the system's stdint.h, which might have
 * additional definitions.
 */
#if 0 /* disabled by -frewrite-includes */
#if __STDC_HOSTED__ && __has_include_next(<stdint.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

// C99 7.18.3 Limits of other integer types
//
//  Footnote 219, 220: C++ implementations should define these macros only when
//  __STDC_LIMIT_MACROS is defined before <stdint.h> is included.
//
//  Footnote 222: C++ implementations should define these macros only when
//  __STDC_CONSTANT_MACROS is defined before <stdint.h> is included.
//
// C++11 [cstdint.syn]p2:
//
//  The macros defined by <cstdint> are provided unconditionally. In particular,
//  the symbols __STDC_LIMIT_MACROS and __STDC_CONSTANT_MACROS (mentioned in
//  footnotes 219, 220, and 222 in the C standard) play no role in C++.
//
// C11 removed the problematic footnotes.
//
// Work around this inconsistency by always defining those macros in C++ mode,
// so that a C library implementation which follows the C99 standard can be
// used in C++.
# ifdef __cplusplus
#if 0 /* disabled by -frewrite-includes */
#  if !defined(__STDC_LIMIT_MACROS)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 47 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#   define __STDC_LIMIT_MACROS
#   define __STDC_LIMIT_MACROS_DEFINED_BY_CLANG
#  endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#  if !defined(__STDC_CONSTANT_MACROS)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 51 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#   define __STDC_CONSTANT_MACROS
#   define __STDC_CONSTANT_MACROS_DEFINED_BY_CLANG
#  endif
# 54 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# endif
# 55 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stdint.h expanded by -frewrite-includes */
# include_next <stdint.h>
#else /* stdint.h expanded by -frewrite-includes */
# 56 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 1 3
/*
 * Copyright (c) 2004, 2005 by
 * Ralf Corsepius, Ulm/Germany. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

#ifndef _STDINT_H
#define _STDINT_H

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _default_types.h expanded by -frewrite-includes */
#include <machine/_default_types.h>
#else /* _default_types.h expanded by -frewrite-includes */
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 1 3
/*
 *  $Id$
 */

#ifndef _MACHINE__DEFAULT_TYPES_H
#define _MACHINE__DEFAULT_TYPES_H

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* features.h expanded by -frewrite-includes */
#include <sys/features.h>
#else /* features.h expanded by -frewrite-includes */
# 8 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 1 3
/*
 *  Written by Joel Sherrill <joel@OARcorp.com>.
 *
 *  COPYRIGHT (c) 1989-2014.
 *
 *  On-Line Applications Research Corporation (OAR).
 *
 *  Permission to use, copy, modify, and distribute this software for any
 *  purpose without fee is hereby granted, provided that this entire notice
 *  is included in all copies of any software which is or includes a copy
 *  or modification of this software.
 *
 *  THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
 *  WARRANTY.  IN PARTICULAR,  THE AUTHOR MAKES NO REPRESENTATION
 *  OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY OF THIS
 *  SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
 *
 *  $Id$
 */

#ifndef _SYS_FEATURES_H
#define _SYS_FEATURES_H

#ifdef __cplusplus
extern "C" {
#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _newlib_version.h expanded by -frewrite-includes */
#include <_newlib_version.h>
#else /* _newlib_version.h expanded by -frewrite-includes */
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_newlib_version.h" 1 3
/* _newlib_version.h.  Generated from _newlib_version.hin by configure.  */
/* Version macros for internal and downstream use. */
#ifndef _NEWLIB_VERSION_H__
#define _NEWLIB_VERSION_H__ 1

#define _NEWLIB_VERSION "4.4.0"
#define __NEWLIB__ 4
#define __NEWLIB_MINOR__ 4
#define __NEWLIB_PATCHLEVEL__ 0

#endif /* !_NEWLIB_VERSION_H__ */
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_newlib_version.h" 3
#endif /* _newlib_version.h expanded by -frewrite-includes */
# 29 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 2 3

/* Macro to test version of GCC.  Returns 0 for non-GCC or too old GCC. */
#ifndef __GNUC_PREREQ
#if 0 /* disabled by -frewrite-includes */
# if defined __GNUC__ && defined __GNUC_MINOR__
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#  define __GNUC_PREREQ(maj, min) \
	((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))
# else
# 36 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#  define __GNUC_PREREQ(maj, min) 0
# endif
# 38 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#endif /* __GNUC_PREREQ */
# 39 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
/* Version with trailing underscores for BSD compatibility. */
#define	__GNUC_PREREQ__(ma, mi)	__GNUC_PREREQ(ma, mi)


/*
 * Feature test macros control which symbols are exposed by the system
 * headers.  Any of these must be defined before including any headers.
 *
 * __STRICT_ANSI__ (defined by gcc -ansi, -std=c90, -std=c99, or -std=c11)
 *	ISO C
 *
 * _POSIX_SOURCE (deprecated by _POSIX_C_SOURCE=1)
 * _POSIX_C_SOURCE >= 1
 * 	POSIX.1-1990
 *
 * _POSIX_C_SOURCE >= 2
 * 	POSIX.2-1992
 *
 * _POSIX_C_SOURCE >= 199309L
 * 	POSIX.1b-1993 Real-time extensions
 *
 * _POSIX_C_SOURCE >= 199506L
 * 	POSIX.1c-1995 Threads extensions
 *
 * _POSIX_C_SOURCE >= 200112L
 * 	POSIX.1-2001 and C99
 *
 * _POSIX_C_SOURCE >= 200809L
 * 	POSIX.1-2008
 *
 * _XOPEN_SOURCE
 *	POSIX.1-1990 and XPG4
 *
 * _XOPEN_SOURCE_EXTENDED
 *	SUSv1 (POSIX.2-1992 plus XPG4v2)
 *
 * _XOPEN_SOURCE >= 500
 *	SUSv2 (POSIX.1c-1995 plus XSI)
 *
 * _XOPEN_SOURCE >= 600
 *	SUSv3 (POSIX.1-2001 plus XSI) and C99
 *
 * _XOPEN_SOURCE >= 700
 *	SUSv4 (POSIX.1-2008 plus XSI)
 *
 * _ISOC99_SOURCE or gcc -std=c99 or g++
 * 	ISO C99
 *
 * _ISOC11_SOURCE or gcc -std=c11 or g++ -std=c++11
 * 	ISO C11
 *
 * _ISOC2x_SOURCE or gcc -std=c2x or g++ -std=c++20
 * 	ISO C11
 *
 * _ATFILE_SOURCE (implied by _POSIX_C_SOURCE >= 200809L)
 *	"at" functions
 *
 * _LARGEFILE_SOURCE (deprecated by _XOPEN_SOURCE >= 500)
 *	fseeko, ftello
 *
 * _GNU_SOURCE
 * 	All of the above plus GNU extensions
 *
 * _BSD_SOURCE (deprecated by _DEFAULT_SOURCE)
 * _SVID_SOURCE (deprecated by _DEFAULT_SOURCE)
 * _DEFAULT_SOURCE (or none of the above)
 * 	POSIX-1.2008 with BSD and SVr4 extensions
 *
 * _FORTIFY_SOURCE = 1 or 2
 * 	Object Size Checking function wrappers
 */

#ifdef _GNU_SOURCE
#undef _ATFILE_SOURCE
#define	_ATFILE_SOURCE		1
#undef	_DEFAULT_SOURCE
#define	_DEFAULT_SOURCE		1
#undef _ISOC99_SOURCE
#define	_ISOC99_SOURCE		1
#undef _ISOC11_SOURCE
#define	_ISOC11_SOURCE		1
#undef _ISOC2X_SOURCE
#define	_ISOC2X_SOURCE		1
#undef _POSIX_SOURCE
#define	_POSIX_SOURCE		1
#undef _POSIX_C_SOURCE
#define	_POSIX_C_SOURCE		200809L
#undef _XOPEN_SOURCE
#define	_XOPEN_SOURCE		700
#undef _XOPEN_SOURCE_EXTENDED
#define	_XOPEN_SOURCE_EXTENDED	1
#endif /* _GNU_SOURCE */
# 131 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_BSD_SOURCE) || defined(_SVID_SOURCE) || \
   (!defined(__STRICT_ANSI__) && !defined(_ANSI_SOURCE) && \
   !defined(_ISOC99_SOURCE) && !defined(_POSIX_SOURCE) && \
   !defined(_POSIX_C_SOURCE) && !defined(_XOPEN_SOURCE))
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 136 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#undef _DEFAULT_SOURCE
#define	_DEFAULT_SOURCE		1
#endif
# 139 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_DEFAULT_SOURCE)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 141 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#undef _POSIX_SOURCE
#define	_POSIX_SOURCE		1
#undef _POSIX_C_SOURCE
#define	_POSIX_C_SOURCE		200809L
#endif
# 146 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(_POSIX_SOURCE) && !defined(_POSIX_C_SOURCE) && \
  ((!defined(__STRICT_ANSI__) && !defined(_ANSI_SOURCE)) || \
   (_XOPEN_SOURCE - 0) >= 500)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 150 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	_POSIX_SOURCE		1
#if 0 /* disabled by -frewrite-includes */
#if !defined(_XOPEN_SOURCE) || (_XOPEN_SOURCE - 0) >= 700
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 152 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	_POSIX_C_SOURCE		200809L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_XOPEN_SOURCE - 0) >= 600
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 154 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	_POSIX_C_SOURCE		200112L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_XOPEN_SOURCE - 0) >= 500
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 156 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	_POSIX_C_SOURCE		199506L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_XOPEN_SOURCE - 0) < 500
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 158 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	_POSIX_C_SOURCE		2
#endif
# 160 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#endif
# 161 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_POSIX_C_SOURCE) && _POSIX_C_SOURCE >= 200809
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 163 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#undef _ATFILE_SOURCE
#define	_ATFILE_SOURCE		1
#endif
# 166 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

/*
 * The following private macros are used throughout the headers to control
 * which symbols should be exposed.  They are for internal use only, as
 * indicated by the leading double underscore, and must never be used outside
 * of these headers.
 *
 * __POSIX_VISIBLE
 * 	any version of POSIX.1; enabled by default, or with _POSIX_SOURCE,
 * 	any value of _POSIX_C_SOURCE, or _XOPEN_SOURCE >= 500.
 *
 * __POSIX_VISIBLE >= 2
 * 	POSIX.2-1992; enabled by default, with _POSIX_C_SOURCE >= 2,
 * 	or _XOPEN_SOURCE >= 500.
 *
 * __POSIX_VISIBLE >= 199309
 * 	POSIX.1b-1993; enabled by default, with _POSIX_C_SOURCE >= 199309L,
 * 	or _XOPEN_SOURCE >= 500.
 *
 * __POSIX_VISIBLE >= 199506
 * 	POSIX.1c-1995; enabled by default, with _POSIX_C_SOURCE >= 199506L,
 * 	or _XOPEN_SOURCE >= 500.
 *
 * __POSIX_VISIBLE >= 200112
 * 	POSIX.1-2001; enabled by default, with _POSIX_C_SOURCE >= 200112L,
 * 	or _XOPEN_SOURCE >= 600.
 *
 * __POSIX_VISIBLE >= 200809
 * 	POSIX.1-2008; enabled by default, with _POSIX_C_SOURCE >= 200809L,
 * 	or _XOPEN_SOURCE >= 700.
 *
 * __XSI_VISIBLE
 *	XPG4 XSI extensions; enabled with any version of _XOPEN_SOURCE.
 *
 * __XSI_VISIBLE >= 4
 *	SUSv1 XSI extensions; enabled with both _XOPEN_SOURCE and
 * 	_XOPEN_SOURCE_EXTENDED together.
 *
 * __XSI_VISIBLE >= 500
 *	SUSv2 XSI extensions; enabled with _XOPEN_SOURCE >= 500.
 *
 * __XSI_VISIBLE >= 600
 *	SUSv3 XSI extensions; enabled with _XOPEN_SOURCE >= 600.
 *
 * __XSI_VISIBLE >= 700
 *	SUSv4 XSI extensions; enabled with _XOPEN_SOURCE >= 700.
 *
 * __ISO_C_VISIBLE >= 1999
 * 	ISO C99; enabled with gcc -std=c99 or newer (on by default since GCC 5),
 * 	any version of C++, or with _ISOC99_SOURCE, _POSIX_C_SOURCE >= 200112L,
 * 	or _XOPEN_SOURCE >= 600.
 *
 * __ISO_C_VISIBLE >= 2011
 * 	ISO C11; enabled with gcc -std=c11 or newer (on by default since GCC 5),
 * 	g++ -std=c++11 or newer (on by default since GCC 6), or with
 * 	_ISOC11_SOURCE.
 *
 * __ISO_C_VISIBLE >= 2020
 * 	ISO C2x; enabled with gcc -std=c2x or newer,
 * 	g++ -std=c++20 or newer, or with
 * 	_ISOC2X_SOURCE.
 *
 * __ATFILE_VISIBLE
 *	"at" functions; enabled by default, with _ATFILE_SOURCE,
 * 	_POSIX_C_SOURCE >= 200809L, or _XOPEN_SOURCE >= 700.
 *
 * __LARGEFILE_VISIBLE
 *	fseeko, ftello; enabled with _LARGEFILE_SOURCE or _XOPEN_SOURCE >= 500.
 *
 * __BSD_VISIBLE
 * 	BSD extensions; enabled by default, or with _BSD_SOURCE.
 *
 * __SVID_VISIBLE
 * 	SVr4 extensions; enabled by default, or with _SVID_SOURCE.
 *
 * __MISC_VISIBLE
 * 	Extensions found in both BSD and SVr4 (shorthand for
 * 	(__BSD_VISIBLE || __SVID_VISIBLE)), or newlib-specific
 * 	extensions; enabled by default.
 *
 * __GNU_VISIBLE
 * 	GNU extensions; enabled with _GNU_SOURCE.
 *
 * __SSP_FORTIFY_LEVEL
 * 	Object Size Checking; defined to 0 (off), 1, or 2.
 *
 * In all cases above, "enabled by default" means either by defining
 * _DEFAULT_SOURCE, or by not defining any of the public feature test macros.
 */

#ifdef _ATFILE_SOURCE
#define	__ATFILE_VISIBLE	1
#else
# 259 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__ATFILE_VISIBLE	0
#endif
# 261 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#ifdef _DEFAULT_SOURCE
#define	__BSD_VISIBLE		1
#else
# 265 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__BSD_VISIBLE		0
#endif
# 267 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#ifdef _GNU_SOURCE
#define	__GNU_VISIBLE		1
#else
# 271 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__GNU_VISIBLE		0
#endif
# 273 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_ISOC2X_SOURCE) || \
  (__STDC_VERSION__ - 0) > 201710L || (__cplusplus - 0) >= 202002L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 276 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define __ISO_C_VISIBLE		2020
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(_ISOC11_SOURCE) || \
  (__STDC_VERSION__ - 0) >= 201112L || (__cplusplus - 0) >= 201103L
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 279 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__ISO_C_VISIBLE		2011
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(_ISOC99_SOURCE) || (_POSIX_C_SOURCE - 0) >= 200112L || \
  (__STDC_VERSION__ - 0) >= 199901L || defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 282 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__ISO_C_VISIBLE		1999
#else
# 284 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__ISO_C_VISIBLE		1990
#endif
# 286 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_LARGEFILE_SOURCE) || (_XOPEN_SOURCE - 0) >= 500
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 288 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__LARGEFILE_VISIBLE	1
#else
# 290 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__LARGEFILE_VISIBLE	0
#endif
# 292 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#ifdef _DEFAULT_SOURCE
#define	__MISC_VISIBLE		1
#else
# 296 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__MISC_VISIBLE		0
#endif
# 298 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if (_POSIX_C_SOURCE - 0) >= 200809L
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 300 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		200809
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_POSIX_C_SOURCE - 0) >= 200112L
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 302 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		200112
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_POSIX_C_SOURCE - 0) >= 199506L
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 304 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		199506
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_POSIX_C_SOURCE - 0) >= 199309L
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 306 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		199309
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_POSIX_C_SOURCE - 0) >= 2 || defined(_XOPEN_SOURCE)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 308 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		199209
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 310 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		199009
#else
# 312 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__POSIX_VISIBLE		0
#endif
# 314 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#ifdef _DEFAULT_SOURCE
#define	__SVID_VISIBLE		1
#else
# 318 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__SVID_VISIBLE		0
#endif
# 320 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if (_XOPEN_SOURCE - 0) >= 700
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 322 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__XSI_VISIBLE		700
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_XOPEN_SOURCE - 0) >= 600
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 324 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__XSI_VISIBLE		600
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (_XOPEN_SOURCE - 0) >= 500
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 326 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__XSI_VISIBLE		500
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(_XOPEN_SOURCE) && defined(_XOPEN_SOURCE_EXTENDED)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 328 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__XSI_VISIBLE		4
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(_XOPEN_SOURCE)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 330 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__XSI_VISIBLE		1
#else
# 332 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define	__XSI_VISIBLE		0
#endif
# 334 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#if 0 /* disabled by -frewrite-includes */
#if _FORTIFY_SOURCE > 0 && !defined(__cplusplus) && !defined(__lint__) && \
   (__OPTIMIZE__ > 0 || defined(__clang__)) && __GNUC_PREREQ__(4, 1) && \
   !defined(_LIBC)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 338 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#if 0 /* disabled by -frewrite-includes */
#  if _FORTIFY_SOURCE > 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 339 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#    define __SSP_FORTIFY_LEVEL 2
#  else
# 341 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#    define __SSP_FORTIFY_LEVEL 1
#  endif
# 343 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#else
# 344 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#  define __SSP_FORTIFY_LEVEL 0
#endif
# 346 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

/* RTEMS adheres to POSIX -- 1003.1b with some features from annexes.  */

#ifdef __rtems__
#define _POSIX_JOB_CONTROL     		1
#define _POSIX_SAVED_IDS       		1
#define _POSIX_VERSION			199309L
#define _POSIX_ASYNCHRONOUS_IO		1
#define _POSIX_FSYNC			1
#define _POSIX_MAPPED_FILES		1
#define _POSIX_MEMLOCK			1
#define _POSIX_MEMLOCK_RANGE		1
#define _POSIX_MEMORY_PROTECTION	1
#define _POSIX_MESSAGE_PASSING		1
#define _POSIX_MONOTONIC_CLOCK		200112L
#define _POSIX_CLOCK_SELECTION		200112L
#define _POSIX_PRIORITIZED_IO		1
#define _POSIX_PRIORITY_SCHEDULING	1
#define _POSIX_REALTIME_SIGNALS		1
#define _POSIX_SEMAPHORES		1
#define _POSIX_SHARED_MEMORY_OBJECTS	1
#define _POSIX_SYNCHRONIZED_IO		1
#define _POSIX_TIMERS			1
#define _POSIX_BARRIERS                 200112L
#define _POSIX_READER_WRITER_LOCKS      200112L
#define _POSIX_SPIN_LOCKS               200112L


/* In P1003.1b but defined by drafts at least as early as P1003.1c/D10  */
#define _POSIX_THREADS				1
#define _POSIX_THREAD_ATTR_STACKADDR		1
#define _POSIX_THREAD_ATTR_STACKSIZE		1
#define _POSIX_THREAD_PRIORITY_SCHEDULING	1
#define _POSIX_THREAD_PRIO_INHERIT		1
#define _POSIX_THREAD_PRIO_PROTECT		1
#define _POSIX_THREAD_PROCESS_SHARED		1
#define _POSIX_THREAD_SAFE_FUNCTIONS		1

/* P1003.4b/D8 defines the constants below this comment. */
#define _POSIX_SPAWN				1
#define _POSIX_TIMEOUTS				1
#define _POSIX_CPUTIME				1
#define _POSIX_THREAD_CPUTIME			1
#define _POSIX_SPORADIC_SERVER			1
#define _POSIX_THREAD_SPORADIC_SERVER		1
#define _POSIX_DEVICE_CONTROL			1
#define _POSIX_DEVCTL_DIRECTION			1
#define _POSIX_INTERRUPT_CONTROL		1
#define _POSIX_ADVISORY_INFO			1

/* UNIX98 added some new pthread mutex attributes */
#define _UNIX98_THREAD_MUTEX_ATTRIBUTES         1

/* POSIX 1003.26-2003 defined device control method */
#define _POSIX_26_VERSION			200312L

#endif
# 403 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

/* XMK loosely adheres to POSIX -- 1003.1 */
#ifdef __XMK__
#define _POSIX_THREADS				1
#define _POSIX_THREAD_PRIORITY_SCHEDULING	1
#endif
# 409 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3


#ifdef __svr4__
# define _POSIX_JOB_CONTROL     1
# define _POSIX_SAVED_IDS       1
# define _POSIX_VERSION 199009L
#endif
# 416 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#ifdef __CYGWIN__

#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE >= 200809
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 420 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_VERSION				200809L
#define _POSIX2_VERSION				200809L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __POSIX_VISIBLE >= 200112
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 423 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_VERSION				200112L
#define _POSIX2_VERSION				200112L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __POSIX_VISIBLE >= 199506
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 426 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_VERSION				199506L
#define _POSIX2_VERSION				199506L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __POSIX_VISIBLE >= 199309
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 429 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_VERSION				199309L
#define _POSIX2_VERSION				199209L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __POSIX_VISIBLE >= 199209
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 432 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_VERSION				199009L
#define _POSIX2_VERSION				199209L
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 435 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_VERSION				199009L
#endif
# 437 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __XSI_VISIBLE >= 4
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 438 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _XOPEN_VERSION				__XSI_VISIBLE
#endif
# 440 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#define _POSIX_ADVISORY_INFO			200809L
#define _POSIX_ASYNCHRONOUS_IO			200809L
#define _POSIX_BARRIERS				200809L
#define _POSIX_CHOWN_RESTRICTED			     1
#define _POSIX_CLOCK_SELECTION			200809L
#define _POSIX_CPUTIME				200809L
#define _POSIX_FSYNC				200809L
#define _POSIX_IPV6				200809L
#define _POSIX_JOB_CONTROL			     1
#define _POSIX_MAPPED_FILES			200809L
/* #define _POSIX_MEMLOCK			    -1 */
#define _POSIX_MEMLOCK_RANGE			200809L
#define _POSIX_MEMORY_PROTECTION		200809L
#define _POSIX_MESSAGE_PASSING			200809L
#define _POSIX_MONOTONIC_CLOCK			200809L
#define _POSIX_NO_TRUNC				     1
/* #define _POSIX_PRIORITIZED_IO		    -1 */
#define _POSIX_PRIORITY_SCHEDULING		200809L
#define _POSIX_RAW_SOCKETS			200809L
#define _POSIX_READER_WRITER_LOCKS		200809L
#define _POSIX_REALTIME_SIGNALS			200809L
#define _POSIX_REGEXP				     1
#define _POSIX_SAVED_IDS			     1
#define _POSIX_SEMAPHORES			200809L
#define _POSIX_SHARED_MEMORY_OBJECTS		200809L
#define _POSIX_SHELL				     1
#define _POSIX_SPAWN				200809L
#define _POSIX_SPIN_LOCKS			200809L
/* #define _POSIX_SPORADIC_SERVER		    -1 */
#define _POSIX_SYNCHRONIZED_IO			200809L
#define _POSIX_THREAD_ATTR_STACKADDR		200809L
#define _POSIX_THREAD_ATTR_STACKSIZE		200809L
#define _POSIX_THREAD_CPUTIME			200809L
/* #define _POSIX_THREAD_PRIO_INHERIT		    -1 */
/* #define _POSIX_THREAD_PRIO_PROTECT		    -1 */
#define _POSIX_THREAD_PRIORITY_SCHEDULING	200809L
#define _POSIX_THREAD_PROCESS_SHARED		200809L
#define _POSIX_THREAD_SAFE_FUNCTIONS		200809L
/* #define _POSIX_THREAD_SPORADIC_SERVER	    -1 */
#define _POSIX_THREADS				200809L
#define _POSIX_TIMEOUTS				200809L
#define _POSIX_TIMERS				200809L
/* #define _POSIX_TRACE				    -1 */
/* #define _POSIX_TRACE_EVENT_FILTER		    -1 */
/* #define _POSIX_TRACE_INHERIT			    -1 */
/* #define _POSIX_TRACE_LOG			    -1 */
/* #define _POSIX_TYPED_MEMORY_OBJECTS		    -1 */
#define _POSIX_VDISABLE				   '\0'

#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE >= 2
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 491 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX2_C_VERSION			_POSIX2_VERSION
#define _POSIX2_C_BIND				_POSIX2_VERSION
#define _POSIX2_C_DEV				_POSIX2_VERSION
#define _POSIX2_CHAR_TERM			_POSIX2_VERSION
/* #define _POSIX2_FORT_DEV			    -1 */
/* #define _POSIX2_FORT_RUN			    -1 */
/* #define _POSIX2_LOCALEDEF			    -1 */
/* #define _POSIX2_PBS				    -1 */
/* #define _POSIX2_PBS_ACCOUNTING		    -1 */
/* #define _POSIX2_PBS_CHECKPOINT		    -1 */
/* #define _POSIX2_PBS_LOCATE			    -1 */
/* #define _POSIX2_PBS_MESSAGE			    -1 */
/* #define _POSIX2_PBS_TRACK			    -1 */
#define _POSIX2_SW_DEV				_POSIX2_VERSION
#define _POSIX2_UPE				_POSIX2_VERSION
#endif /* __POSIX_VISIBLE >= 2 */
# 507 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#define _POSIX_V6_ILP32_OFF32			    -1
#ifdef __LP64__
#define _POSIX_V6_ILP32_OFFBIG			    -1
#define _POSIX_V6_LP64_OFF64			     1
#define _POSIX_V6_LPBIG_OFFBIG			     1
#else
# 514 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_V6_ILP32_OFFBIG			     1
#define _POSIX_V6_LP64_OFF64			    -1
#define _POSIX_V6_LPBIG_OFFBIG			    -1
#endif
# 518 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _POSIX_V7_ILP32_OFF32			_POSIX_V6_ILP32_OFF32
#define _POSIX_V7_ILP32_OFFBIG			_POSIX_V6_ILP32_OFFBIG
#define _POSIX_V7_LP64_OFF64			_POSIX_V6_LP64_OFF64
#define _POSIX_V7_LPBIG_OFFBIG			_POSIX_V6_LPBIG_OFFBIG
#define _XBS5_ILP32_OFF32			_POSIX_V6_ILP32_OFF32
#define _XBS5_ILP32_OFFBIG			_POSIX_V6_ILP32_OFFBIG
#define _XBS5_LP64_OFF64			_POSIX_V6_LP64_OFF64
#define _XBS5_LPBIG_OFFBIG			_POSIX_V6_LPBIG_OFFBIG

#if 0 /* disabled by -frewrite-includes */
#if __XSI_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 528 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#define _XOPEN_CRYPT				     1
#define _XOPEN_ENH_I18N				     1
/* #define _XOPEN_LEGACY			    -1 */
/* #define _XOPEN_REALTIME			    -1 */
/* #define _XOPEN_REALTIME_THREADS		    -1 */
#define _XOPEN_SHM				     1
/* #define _XOPEN_STREAMS			    -1 */
/* #define _XOPEN_UNIX				    -1 */
#endif /* __XSI_VISIBLE */
# 537 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

/*
 * newlib's wide char conversion functions were updated on
 *	2019-01-12
 * to UNICODE version:
 *	11.0.0 released 2018-06-05
 */
#define __STDC_ISO_10646__ 201806L

#endif /* __CYGWIN__ */
# 547 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3

#ifdef __cplusplus
}
#endif
# 551 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#endif /* _SYS_FEATURES_H */
# 552 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/features.h" 3
#endif /* features.h expanded by -frewrite-includes */
# 9 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 2 3

/*
 * Guess on types by examining *_MIN / *_MAX defines.
 */
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ (3, 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
/* GCC >= 3.3.0 has __<val>__ implicitly defined. */
#define __EXP(x) __##x##__
#else
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
/* Fall back to POSIX versions from <limits.h> */
#define __EXP(x) x
#if 0 /* expanded by -frewrite-includes */
#include <limits.h>
#endif /* expanded by -frewrite-includes */
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
# 20 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

/* Check if "long long" is 64bit wide */
/* Modern GCCs provide __LONG_LONG_MAX__, SUSv3 wants LLONG_MAX */
#if 0 /* disabled by -frewrite-includes */
#if ( defined(__LONG_LONG_MAX__) && (__LONG_LONG_MAX__ > 0x7fffffff) ) \
  || ( defined(LLONG_MAX) && (LLONG_MAX > 0x7fffffff) )
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define __have_longlong64 1
#endif
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

/* Check if "long" is 64bit or 32bit wide */
#if 0 /* disabled by -frewrite-includes */
#if __EXP(LONG_MAX) > 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define __have_long64 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(LONG_MAX) == 0x7fffffff && !defined(__SPU__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define __have_long32 1
#endif
# 35 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __cplusplus
extern "C" {
#endif
# 39 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT8_TYPE__
typedef __INT8_TYPE__ __int8_t;
#ifdef __UINT8_TYPE__
typedef __UINT8_TYPE__ __uint8_t;
#else
# 45 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT8_TYPE__ __uint8_t;
#endif
# 47 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int8_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(SCHAR_MAX) == 0x7f
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 49 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed char __int8_t ;
typedef unsigned char __uint8_t ;
#define ___int8_t_defined 1
#endif
# 53 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT16_TYPE__
typedef __INT16_TYPE__ __int16_t;
#ifdef __UINT16_TYPE__
typedef __UINT16_TYPE__ __uint16_t;
#else
# 59 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT16_TYPE__ __uint16_t;
#endif
# 61 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(INT_MAX) == 0x7fff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 63 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed int __int16_t;
typedef unsigned int __uint16_t;
#define ___int16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(SHRT_MAX) == 0x7fff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 67 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed short __int16_t;
typedef unsigned short __uint16_t;
#define ___int16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(SCHAR_MAX) == 0x7fff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed char __int16_t;
typedef unsigned char __uint16_t;
#define ___int16_t_defined 1
#endif
# 75 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT32_TYPE__
typedef __INT32_TYPE__ __int32_t;
#ifdef __UINT32_TYPE__
typedef __UINT32_TYPE__ __uint32_t;
#else
# 81 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT32_TYPE__ __uint32_t;
#endif
# 83 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(INT_MAX) == 0x7fffffffL
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
#define ___int32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(LONG_MAX) == 0x7fffffffL
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed long __int32_t;
typedef unsigned long __uint32_t;
#define ___int32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(SHRT_MAX) == 0x7fffffffL
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed short __int32_t;
typedef unsigned short __uint32_t;
#define ___int32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(SCHAR_MAX) == 0x7fffffffL
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 97 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed char __int32_t;
typedef unsigned char __uint32_t;
#define ___int32_t_defined 1
#endif
# 101 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT64_TYPE__
typedef __INT64_TYPE__ __int64_t;
#ifdef __UINT64_TYPE__
typedef __UINT64_TYPE__ __uint64_t;
#else
# 107 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT64_TYPE__ __uint64_t;
#endif
# 109 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int64_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __EXP(LONG_MAX) > 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 111 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed long __int64_t;
typedef unsigned long __uint64_t;
#define ___int64_t_defined 1

/* GCC has __LONG_LONG_MAX__ */
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif  defined(__LONG_LONG_MAX__) && (__LONG_LONG_MAX__ > 0x7fffffff)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 117 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed long long __int64_t;
typedef unsigned long long __uint64_t;
#define ___int64_t_defined 1

/* POSIX mandates LLONG_MAX in <limits.h> */
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif  defined(LLONG_MAX) && (LLONG_MAX > 0x7fffffff)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed long long __int64_t;
typedef unsigned long long __uint64_t;
#define ___int64_t_defined 1

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif  __EXP(INT_MAX) > 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed int __int64_t;
typedef unsigned int __uint64_t;
#define ___int64_t_defined 1
#endif
# 132 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT_LEAST8_TYPE__
typedef __INT_LEAST8_TYPE__ __int_least8_t;
#ifdef __UINT_LEAST8_TYPE__
typedef __UINT_LEAST8_TYPE__ __uint_least8_t;
#else
# 138 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT_LEAST8_TYPE__ __uint_least8_t;
#endif
# 140 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int_least8_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int8_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 142 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int8_t __int_least8_t;
typedef __uint8_t __uint_least8_t;
#define ___int_least8_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int16_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 146 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int16_t __int_least8_t;
typedef __uint16_t __uint_least8_t;
#define ___int_least8_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int32_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 150 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int32_t __int_least8_t;
typedef __uint32_t __uint_least8_t;
#define ___int_least8_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 154 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int64_t __int_least8_t;
typedef __uint64_t __uint_least8_t;
#define ___int_least8_t_defined 1
#endif
# 158 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT_LEAST16_TYPE__
typedef __INT_LEAST16_TYPE__ __int_least16_t;
#ifdef __UINT_LEAST16_TYPE__
typedef __UINT_LEAST16_TYPE__ __uint_least16_t;
#else
# 164 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT_LEAST16_TYPE__ __uint_least16_t;
#endif
# 166 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int_least16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int16_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 168 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int16_t __int_least16_t;
typedef __uint16_t __uint_least16_t;
#define ___int_least16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int32_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 172 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int32_t __int_least16_t;
typedef __uint32_t __uint_least16_t;
#define ___int_least16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 176 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int64_t __int_least16_t;
typedef __uint64_t __uint_least16_t;
#define ___int_least16_t_defined 1
#endif
# 180 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT_LEAST32_TYPE__
typedef __INT_LEAST32_TYPE__ __int_least32_t;
#ifdef __UINT_LEAST32_TYPE__
typedef __UINT_LEAST32_TYPE__ __uint_least32_t;
#else
# 186 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT_LEAST32_TYPE__ __uint_least32_t;
#endif
# 188 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int_least32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int32_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 190 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int32_t __int_least32_t;
typedef __uint32_t __uint_least32_t;
#define ___int_least32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 194 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int64_t __int_least32_t;
typedef __uint64_t __uint_least32_t;
#define ___int_least32_t_defined 1
#endif
# 198 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INT_LEAST64_TYPE__
typedef __INT_LEAST64_TYPE__ __int_least64_t;
#ifdef __UINT_LEAST64_TYPE__
typedef __UINT_LEAST64_TYPE__ __uint_least64_t;
#else
# 204 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INT_LEAST64_TYPE__ __uint_least64_t;
#endif
# 206 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#define ___int_least64_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(___int64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 208 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __int64_t __int_least64_t;
typedef __uint64_t __uint_least64_t;
#define ___int_least64_t_defined 1
#endif
# 212 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__INTMAX_TYPE__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 214 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __INTMAX_TYPE__ __intmax_t;
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __have_longlong64
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 216 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed long long __intmax_t;
#else
# 218 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef signed long __intmax_t;
#endif
# 220 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__UINTMAX_TYPE__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 222 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __UINTMAX_TYPE__ __uintmax_t;
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __have_longlong64
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 224 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned long long __uintmax_t;
#else
# 226 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned long __uintmax_t;
#endif
# 228 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#ifdef __INTPTR_TYPE__
typedef __INTPTR_TYPE__ __intptr_t;
#ifdef __UINTPTR_TYPE__
typedef __UINTPTR_TYPE__ __uintptr_t;
#else
# 234 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef unsigned __INTPTR_TYPE__ __uintptr_t;
#endif
# 236 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__PTRDIFF_TYPE__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 237 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef __PTRDIFF_TYPE__ __intptr_t;
typedef unsigned __PTRDIFF_TYPE__ __uintptr_t;
#else
# 240 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
typedef long __intptr_t;
typedef unsigned long __uintptr_t;
#endif
# 243 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#undef __EXP

#ifdef __cplusplus
}
#endif
# 249 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3

#endif /* _MACHINE__DEFAULT_TYPES_H */
# 251 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_default_types.h" 3
#endif /* _default_types.h expanded by -frewrite-includes */
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 2 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _intsup.h expanded by -frewrite-includes */
#include <sys/_intsup.h>
#else /* _intsup.h expanded by -frewrite-includes */
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 1 3
/*
 * Copyright (c) 2004, 2005 by
 * Ralf Corsepius, Ulm/Germany. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

#ifndef _SYS__INTSUP_H
#define _SYS__INTSUP_H

#if 0 /* expanded by -frewrite-includes */
#include <sys/features.h>
#endif /* expanded by -frewrite-includes */
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ (3, 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 15 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
/* gcc > 3.2 implicitly defines the values we are interested */
#define __STDINT_EXP(x) __##x##__
#else
# 18 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __STDINT_EXP(x) x
#if 0 /* expanded by -frewrite-includes */
#include <limits.h>
#endif /* expanded by -frewrite-includes */
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
# 20 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3

/* Determine how intptr_t and intN_t fastN_t and leastN_t are defined by gcc
   for this target.  This is used to determine the correct printf() constant in
   inttypes.h and other  constants in stdint.h.
   So we end up with
   ?(signed|unsigned) char == 0
   ?(signed|unsigned) short == 1
   ?(signed|unsigned) int == 2
   ?(signed|unsigned) short int == 3
   ?(signed|unsigned) long == 4
   ?(signed|unsigned) long int == 6
   ?(signed|unsigned) long long == 8
   ?(signed|unsigned) long long int == 10
 */
#pragma push_macro("signed")
#pragma push_macro("unsigned")
#pragma push_macro("char")
#pragma push_macro("short")
#pragma push_macro("__int20")
#pragma push_macro("__int20__")
#pragma push_macro("int")
#pragma push_macro("long")
#undef signed
#undef unsigned
#undef char
#undef short
#undef int
#undef __int20
#undef __int20__
#undef long
#define signed +0
#define unsigned +0
#define char +0
#define short +1
#define __int20 +2
#define __int20__ +2
#define int +2
#define long +4
#if 0 /* disabled by -frewrite-includes */
#if (__INTPTR_TYPE__ == 8 || __INTPTR_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 60 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define _INTPTR_EQ_LONGLONG
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INTPTR_TYPE__ == 4 || __INTPTR_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 62 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define _INTPTR_EQ_LONG
/* Note - the tests for _INTPTR_EQ_INT and _INTPTR_EQ_SHORT are currently
   redundant as the values are not used.  But one day they may be needed
   and so the tests remain.  */
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __INTPTR_TYPE__ == 2
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 67 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define _INTPTR_EQ_INT
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INTPTR_TYPE__ == 1 || __INTPTR_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 69 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define _INTPTR_EQ_SHORT
#else
# 71 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#error "Unable to determine type definition of intptr_t"
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT32_TYPE__ == 4 || __INT32_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define _INT32_EQ_LONG
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __INT32_TYPE__ == 2
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 76 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
/* Nothing to define because int32_t is safe to print as an int. */
#else
# 78 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#error "Unable to determine type definition of int32_t"
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3

#if 0 /* disabled by -frewrite-includes */
#if (__INT8_TYPE__ == 0)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 82 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT8 "hh"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT8_TYPE__ == 1 || __INT8_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT8 "h"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT8_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 86 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT8
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT8_TYPE__ == 4 || __INT8_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT8 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT8_TYPE__ == 8 || __INT8_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 90 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT8 "ll"
#endif
# 92 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT16_TYPE__ == 1 || __INT16_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT16 "h"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT16_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 95 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT16
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT16_TYPE__ == 4 || __INT16_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 97 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT16 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT16_TYPE__ == 8 || __INT16_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 99 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT16 "ll"
#endif
# 101 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT32_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 102 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT32
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT32_TYPE__ == 4 || __INT32_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT32 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT32_TYPE__ == 8 || __INT32_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 106 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT32 "ll"
#endif
# 108 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT64_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 109 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT64
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT64_TYPE__ == 4 || __INT64_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 111 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT64 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT64_TYPE__ == 8 || __INT64_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __INT64 "ll"
#endif
# 115 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_FAST8_TYPE__ == 0)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 116 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST8 "hh"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST8_TYPE__ == 1 || __INT_FAST8_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST8 "h"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST8_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 120 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST8
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST8_TYPE__ == 4 || __INT_FAST8_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 122 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST8 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST8_TYPE__ == 8 || __INT_FAST8_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 124 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST8 "ll"
#endif
# 126 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_FAST16_TYPE__ == 1 || __INT_FAST16_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 127 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST16 "h"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST16_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 129 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST16
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST16_TYPE__ == 4 || __INT_FAST16_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 131 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST16 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST16_TYPE__ == 8 || __INT_FAST16_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 133 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST16 "ll"
#endif
# 135 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_FAST32_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 136 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST32
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST32_TYPE__ == 4 || __INT_FAST32_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 138 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST32 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST32_TYPE__ == 8 || __INT_FAST32_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 140 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST32 "ll"
#endif
# 142 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_FAST64_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 143 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST64
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST64_TYPE__ == 4 || __INT_FAST64_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 145 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST64 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_FAST64_TYPE__ == 8 || __INT_FAST64_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 147 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __FAST64 "ll"
#endif
# 149 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3

#if 0 /* disabled by -frewrite-includes */
#if (__INT_LEAST8_TYPE__ == 0)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 151 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST8 "hh"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST8_TYPE__ == 1 || __INT_LEAST8_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 153 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST8 "h"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST8_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 155 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST8
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST8_TYPE__ == 4 || __INT_LEAST8_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 157 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST8 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST8_TYPE__ == 8 || __INT_LEAST8_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 159 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST8 "ll"
#endif
# 161 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_LEAST16_TYPE__ == 1 || __INT_LEAST16_TYPE__ == 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 162 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST16 "h"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST16_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 164 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST16
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST16_TYPE__ == 4 || __INT_LEAST16_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 166 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST16 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST16_TYPE__ == 8 || __INT_LEAST16_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 168 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST16 "ll"
#endif
# 170 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_LEAST32_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 171 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST32
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST32_TYPE__ == 4 || __INT_LEAST32_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 173 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST32 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST32_TYPE__ == 8 || __INT_LEAST32_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 175 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST32 "ll"
#endif
# 177 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__INT_LEAST64_TYPE__ == 2)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 178 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST64
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST64_TYPE__ == 4 || __INT_LEAST64_TYPE__ == 6)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 180 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST64 "l"
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif (__INT_LEAST64_TYPE__ == 8 || __INT_LEAST64_TYPE__ == 10)
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 182 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#define __LEAST64 "ll"
#endif
# 184 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#undef signed
#undef unsigned
#undef char
#undef short
#undef int
#undef long
#pragma pop_macro("signed")
#pragma pop_macro("unsigned")
#pragma pop_macro("char")
#pragma pop_macro("short")
#pragma pop_macro("__int20")
#pragma pop_macro("__int20__")
#pragma pop_macro("int")
#pragma pop_macro("long")

#endif /* _SYS__INTSUP_H */
# 200 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_intsup.h" 3
#endif /* _intsup.h expanded by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 2 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _stdint.h expanded by -frewrite-includes */
#include <sys/_stdint.h>
#else /* _stdint.h expanded by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 1 3
/*
 * Copyright (c) 2004, 2005 by
 * Ralf Corsepius, Ulm/Germany. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

#ifndef _SYS__STDINT_H
#define _SYS__STDINT_H

#if 0 /* expanded by -frewrite-includes */
#include <machine/_default_types.h>
#endif /* expanded by -frewrite-includes */
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifdef __cplusplus
extern "C" {
#endif
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifdef ___int8_t_defined
#ifndef _INT8_T_DECLARED
typedef __int8_t int8_t ;
#define _INT8_T_DECLARED
#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#ifndef _UINT8_T_DECLARED
typedef __uint8_t uint8_t ;
#define _UINT8_T_DECLARED
#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#define __int8_t_defined 1
#endif /* ___int8_t_defined */
# 29 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifdef ___int16_t_defined
#ifndef _INT16_T_DECLARED
typedef __int16_t int16_t ;
#define _INT16_T_DECLARED
#endif
# 35 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#ifndef _UINT16_T_DECLARED
typedef __uint16_t uint16_t ;
#define _UINT16_T_DECLARED
#endif
# 39 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#define __int16_t_defined 1
#endif /* ___int16_t_defined */
# 41 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifdef ___int32_t_defined
#ifndef _INT32_T_DECLARED
typedef __int32_t int32_t ;
#define _INT32_T_DECLARED
#endif
# 47 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#ifndef _UINT32_T_DECLARED
typedef __uint32_t uint32_t ;
#define _UINT32_T_DECLARED
#endif
# 51 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#define __int32_t_defined 1
#endif /* ___int32_t_defined */
# 53 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifdef ___int64_t_defined
#ifndef _INT64_T_DECLARED
typedef __int64_t int64_t ;
#define _INT64_T_DECLARED
#endif
# 59 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#ifndef _UINT64_T_DECLARED
typedef __uint64_t uint64_t ;
#define _UINT64_T_DECLARED
#endif
# 63 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#define __int64_t_defined 1
#endif /* ___int64_t_defined */
# 65 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifndef _INTMAX_T_DECLARED
typedef __intmax_t intmax_t;
#define _INTMAX_T_DECLARED
#endif
# 70 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifndef _UINTMAX_T_DECLARED
typedef __uintmax_t uintmax_t;
#define _UINTMAX_T_DECLARED
#endif
# 75 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifndef _INTPTR_T_DECLARED
typedef __intptr_t intptr_t;
#define _INTPTR_T_DECLARED
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifndef _UINTPTR_T_DECLARED
typedef __uintptr_t uintptr_t;
#define _UINTPTR_T_DECLARED
#endif
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#ifdef __cplusplus
}
#endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3

#endif /* _SYS__STDINT_H */
# 91 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_stdint.h" 3
#endif /* _stdint.h expanded by -frewrite-includes */
# 15 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 2 3

#ifdef __cplusplus
extern "C" {
#endif
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef ___int_least8_t_defined
typedef __int_least8_t int_least8_t;
typedef __uint_least8_t uint_least8_t;
#define __int_least8_t_defined 1
#endif
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef ___int_least16_t_defined
typedef __int_least16_t int_least16_t;
typedef __uint_least16_t uint_least16_t;
#define __int_least16_t_defined 1
#endif
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef ___int_least32_t_defined
typedef __int_least32_t int_least32_t;
typedef __uint_least32_t uint_least32_t;
#define __int_least32_t_defined 1
#endif
# 37 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef ___int_least64_t_defined
typedef __int_least64_t int_least64_t;
typedef __uint_least64_t uint_least64_t;
#define __int_least64_t_defined 1
#endif
# 43 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/*
 * Fastest minimum-width integer types
 *
 * Assume int to be the fastest type for all types with a width 
 * less than __INT_MAX__ rsp. INT_MAX
 */
#ifdef __INT_FAST8_TYPE__
  typedef __INT_FAST8_TYPE__ int_fast8_t;
  typedef __UINT_FAST8_TYPE__ uint_fast8_t;
#define __int_fast8_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __STDINT_EXP(INT_MAX) >= 0x7f
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 55 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef signed int int_fast8_t;
  typedef unsigned int uint_fast8_t;
#define __int_fast8_t_defined 1
#endif
# 59 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST16_TYPE__
  typedef __INT_FAST16_TYPE__ int_fast16_t;
  typedef __UINT_FAST16_TYPE__ uint_fast16_t;
#define __int_fast16_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __STDINT_EXP(INT_MAX) >= 0x7fff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 65 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef signed int int_fast16_t;
  typedef unsigned int uint_fast16_t;
#define __int_fast16_t_defined 1
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST32_TYPE__
  typedef __INT_FAST32_TYPE__ int_fast32_t;
  typedef __UINT_FAST32_TYPE__ uint_fast32_t;
#define __int_fast32_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __STDINT_EXP(INT_MAX) >= 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 75 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef signed int int_fast32_t;
  typedef unsigned int uint_fast32_t;
#define __int_fast32_t_defined 1
#endif
# 79 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST64_TYPE__
  typedef __INT_FAST64_TYPE__ int_fast64_t;
  typedef __UINT_FAST64_TYPE__ uint_fast64_t;
#define __int_fast64_t_defined 1
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __STDINT_EXP(INT_MAX) > 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef signed int int_fast64_t;
  typedef unsigned int uint_fast64_t;
#define __int_fast64_t_defined 1
#endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/*
 * Fall back to [u]int_least<N>_t for [u]int_fast<N>_t types
 * not having been defined, yet.
 * Leave undefined, if [u]int_least<N>_t should not be available.
 */
#if 0 /* disabled by -frewrite-includes */
#if !__int_fast8_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 96 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __int_least8_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 97 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef int_least8_t int_fast8_t;
  typedef uint_least8_t uint_fast8_t;
#define __int_fast8_t_defined 1
#endif
# 101 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 102 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__int_fast16_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __int_least16_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 105 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef int_least16_t int_fast16_t;
  typedef uint_least16_t uint_fast16_t;
#define __int_fast16_t_defined 1
#endif
# 109 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 110 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__int_fast32_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 112 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __int_least32_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef int_least32_t int_fast32_t;
  typedef uint_least32_t uint_fast32_t;
#define __int_fast32_t_defined 1
#endif
# 117 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 118 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__int_fast64_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 120 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __int_least64_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 121 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
  typedef int_least64_t int_fast64_t;
  typedef uint_least64_t uint_fast64_t;
#define __int_fast64_t_defined 1
#endif
# 125 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 126 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INTPTR_TYPE__
#define INTPTR_MIN (-__INTPTR_MAX__ - 1)
#define INTPTR_MAX (__INTPTR_MAX__)
#define UINTPTR_MAX (__UINTPTR_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__PTRDIFF_TYPE__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 132 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INTPTR_MAX PTRDIFF_MAX
#define INTPTR_MIN PTRDIFF_MIN
#ifdef __UINTPTR_MAX__
#define UINTPTR_MAX (__UINTPTR_MAX__)
#else
# 137 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define UINTPTR_MAX (2UL * PTRDIFF_MAX + 1)
#endif
# 139 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#else
# 140 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
/*
 * Fallback to hardcoded values, 
 * should be valid on cpu's with 32bit int/32bit void*
 */
#define INTPTR_MAX (__STDINT_EXP(LONG_MAX))
#define INTPTR_MIN (-__STDINT_EXP(LONG_MAX) - 1)
#define UINTPTR_MAX (__STDINT_EXP(LONG_MAX) * 2UL + 1)
#endif
# 148 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/* Limits of Specified-Width Integer Types */

#ifdef __INT8_MAX__
#define INT8_MIN (-__INT8_MAX__ - 1)
#define INT8_MAX (__INT8_MAX__)
#define UINT8_MAX (__UINT8_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int8_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 156 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT8_MIN 	(-128)
#define INT8_MAX 	 (127)
#define UINT8_MAX 	 (255)
#endif
# 160 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_LEAST8_MAX__
#define INT_LEAST8_MIN (-__INT_LEAST8_MAX__ - 1)
#define INT_LEAST8_MAX (__INT_LEAST8_MAX__)
#define UINT_LEAST8_MAX (__UINT_LEAST8_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_least8_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 166 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_LEAST8_MIN 	(-128)
#define INT_LEAST8_MAX 	 (127)
#define UINT_LEAST8_MAX	 (255)
#else
# 170 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#error required type int_least8_t missing
#endif
# 172 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT16_MAX__
#define INT16_MIN (-__INT16_MAX__ - 1)
#define INT16_MAX (__INT16_MAX__)
#define UINT16_MAX (__UINT16_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int16_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 178 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT16_MIN 	(-32768)
#define INT16_MAX 	 (32767)
#define UINT16_MAX 	 (65535)
#endif
# 182 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_LEAST16_MAX__
#define INT_LEAST16_MIN (-__INT_LEAST16_MAX__ - 1)
#define INT_LEAST16_MAX (__INT_LEAST16_MAX__)
#define UINT_LEAST16_MAX (__UINT_LEAST16_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_least16_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 188 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_LEAST16_MIN	(-32768)
#define INT_LEAST16_MAX	 (32767)
#define UINT_LEAST16_MAX (65535)
#else
# 192 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#error required type int_least16_t missing
#endif
# 194 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT32_MAX__
#define INT32_MIN (-__INT32_MAX__ - 1)
#define INT32_MAX (__INT32_MAX__)
#define UINT32_MAX (__UINT32_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int32_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 200 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined (_INT32_EQ_LONG)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 201 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT32_MIN 	 (-2147483647L-1)
#define INT32_MAX 	 (2147483647L)
#define UINT32_MAX       (4294967295UL)
#else
# 205 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT32_MIN 	 (-2147483647-1)
#define INT32_MAX 	 (2147483647)
#define UINT32_MAX       (4294967295U)
#endif
# 209 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 210 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_LEAST32_MAX__
#define INT_LEAST32_MIN (-__INT_LEAST32_MAX__ - 1)
#define INT_LEAST32_MAX (__INT_LEAST32_MAX__)
#define UINT_LEAST32_MAX (__UINT_LEAST32_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_least32_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 216 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined (_INT32_EQ_LONG)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 217 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_LEAST32_MIN  (-2147483647L-1)
#define INT_LEAST32_MAX  (2147483647L)
#define UINT_LEAST32_MAX (4294967295UL)
#else
# 221 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_LEAST32_MIN  (-2147483647-1)
#define INT_LEAST32_MAX  (2147483647)
#define UINT_LEAST32_MAX (4294967295U)
#endif
# 225 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#else
# 226 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#error required type int_least32_t missing
#endif
# 228 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT64_MAX__
#define INT64_MIN (-__INT64_MAX__ - 1)
#define INT64_MAX (__INT64_MAX__)
#define UINT64_MAX (__UINT64_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 234 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __have_long64
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 235 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT64_MIN 	(-9223372036854775807L-1L)
#define INT64_MAX 	 (9223372036854775807L)
#define UINT64_MAX 	(18446744073709551615U)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __have_longlong64
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 239 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT64_MIN 	(-9223372036854775807LL-1LL)
#define INT64_MAX 	 (9223372036854775807LL)
#define UINT64_MAX 	(18446744073709551615ULL)
#endif
# 243 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 244 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_LEAST64_MAX__
#define INT_LEAST64_MIN (-__INT_LEAST64_MAX__ - 1)
#define INT_LEAST64_MAX (__INT_LEAST64_MAX__)
#define UINT_LEAST64_MAX (__UINT_LEAST64_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_least64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 250 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __have_long64
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 251 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_LEAST64_MIN  (-9223372036854775807L-1L)
#define INT_LEAST64_MAX  (9223372036854775807L)
#define UINT_LEAST64_MAX (18446744073709551615U)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __have_longlong64
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 255 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_LEAST64_MIN  (-9223372036854775807LL-1LL)
#define INT_LEAST64_MAX  (9223372036854775807LL)
#define UINT_LEAST64_MAX (18446744073709551615ULL)
#endif
# 259 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 260 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST8_MAX__
#define INT_FAST8_MIN (-__INT_FAST8_MAX__ - 1)
#define INT_FAST8_MAX (__INT_FAST8_MAX__)
#define UINT_FAST8_MAX (__UINT_FAST8_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_fast8_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 266 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __STDINT_EXP(INT_MAX) >= 0x7f
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 267 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST8_MIN	(-__STDINT_EXP(INT_MAX)-1)
#define INT_FAST8_MAX	(__STDINT_EXP(INT_MAX))
#define UINT_FAST8_MAX	(__STDINT_EXP(INT_MAX)*2U+1U)
#else
# 271 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST8_MIN	INT_LEAST8_MIN
#define INT_FAST8_MAX	INT_LEAST8_MAX
#define UINT_FAST8_MAX	UINT_LEAST8_MAX
#endif
# 275 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 276 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST16_MAX__
#define INT_FAST16_MIN (-__INT_FAST16_MAX__ - 1)
#define INT_FAST16_MAX (__INT_FAST16_MAX__)
#define UINT_FAST16_MAX (__UINT_FAST16_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_fast16_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 282 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __STDINT_EXP(INT_MAX) >= 0x7fff
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 283 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST16_MIN	(-__STDINT_EXP(INT_MAX)-1)
#define INT_FAST16_MAX	(__STDINT_EXP(INT_MAX))
#define UINT_FAST16_MAX	(__STDINT_EXP(INT_MAX)*2U+1U)
#else
# 287 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST16_MIN	INT_LEAST16_MIN
#define INT_FAST16_MAX	INT_LEAST16_MAX
#define UINT_FAST16_MAX	UINT_LEAST16_MAX
#endif
# 291 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 292 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST32_MAX__
#define INT_FAST32_MIN (-__INT_FAST32_MAX__ - 1)
#define INT_FAST32_MAX (__INT_FAST32_MAX__)
#define UINT_FAST32_MAX (__UINT_FAST32_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_fast32_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 298 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __STDINT_EXP(INT_MAX) >= 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 299 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST32_MIN	(-__STDINT_EXP(INT_MAX)-1)
#define INT_FAST32_MAX	(__STDINT_EXP(INT_MAX))
#define UINT_FAST32_MAX	(__STDINT_EXP(INT_MAX)*2U+1U)
#else
# 303 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST32_MIN	INT_LEAST32_MIN
#define INT_FAST32_MAX	INT_LEAST32_MAX
#define UINT_FAST32_MAX	UINT_LEAST32_MAX
#endif
# 307 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 308 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT_FAST64_MAX__
#define INT_FAST64_MIN (-__INT_FAST64_MAX__ - 1)
#define INT_FAST64_MAX (__INT_FAST64_MAX__)
#define UINT_FAST64_MAX (__UINT_FAST64_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__int_fast64_t_defined)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 314 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __STDINT_EXP(INT_MAX) > 0x7fffffff
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 315 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST64_MIN	(-__STDINT_EXP(INT_MAX)-1)
#define INT_FAST64_MAX	(__STDINT_EXP(INT_MAX))
#define UINT_FAST64_MAX	(__STDINT_EXP(INT_MAX)*2U+1U)
#else
# 319 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT_FAST64_MIN	INT_LEAST64_MIN
#define INT_FAST64_MAX	INT_LEAST64_MAX
#define UINT_FAST64_MAX	UINT_LEAST64_MAX
#endif
# 323 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 324 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INTMAX_MAX__
#define INTMAX_MAX (__INTMAX_MAX__)
#define INTMAX_MIN (-INTMAX_MAX - 1)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__INTMAX_TYPE__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 329 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
/* All relevant GCC versions prefer long to long long for intmax_t.  */
#define INTMAX_MAX INT64_MAX
#define INTMAX_MIN INT64_MIN
#endif
# 333 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __UINTMAX_MAX__
#define UINTMAX_MAX (__UINTMAX_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__UINTMAX_TYPE__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 337 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
/* All relevant GCC versions prefer long to long long for intmax_t.  */
#define UINTMAX_MAX UINT64_MAX
#endif
# 340 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/* This must match size_t in stddef.h, currently long unsigned int */
#ifdef __SIZE_MAX__
#define SIZE_MAX (__SIZE_MAX__)
#else
# 345 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define SIZE_MAX (__STDINT_EXP(LONG_MAX) * 2UL + 1)
#endif
# 347 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/* This must match sig_atomic_t in <signal.h> (currently int) */
#define SIG_ATOMIC_MIN (-__STDINT_EXP(INT_MAX) - 1)
#define SIG_ATOMIC_MAX (__STDINT_EXP(INT_MAX))

/* This must match ptrdiff_t  in <stddef.h> (currently long int) */
#ifdef __PTRDIFF_MAX__
#define PTRDIFF_MAX (__PTRDIFF_MAX__)
#else
# 356 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define PTRDIFF_MAX (__STDINT_EXP(LONG_MAX))
#endif
# 358 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define PTRDIFF_MIN (-PTRDIFF_MAX - 1)

/* This must match definition in <wchar.h> */
#ifndef WCHAR_MIN
#ifdef __WCHAR_MIN__
#define WCHAR_MIN (__WCHAR_MIN__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__WCHAR_UNSIGNED__) || (L'\0' - 1 > 0)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 365 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define WCHAR_MIN (0 + L'\0')
#else
# 367 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define WCHAR_MIN (-0x7fffffff - 1 + L'\0')
#endif
# 369 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 370 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/* This must match definition in <wchar.h> */
#ifndef WCHAR_MAX
#ifdef __WCHAR_MAX__
#define WCHAR_MAX (__WCHAR_MAX__)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__WCHAR_UNSIGNED__) || (L'\0' - 1 > 0)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 376 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define WCHAR_MAX (0xffffffffu + L'\0')
#else
# 378 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define WCHAR_MAX (0x7fffffff + L'\0')
#endif
# 380 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 381 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/* wint_t is unsigned int on almost all GCC targets.  */
#ifdef __WINT_MAX__
#define WINT_MAX (__WINT_MAX__)
#else
# 386 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define WINT_MAX (__STDINT_EXP(INT_MAX) * 2U + 1U)
#endif
# 388 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#ifdef __WINT_MIN__
#define WINT_MIN (__WINT_MIN__)
#else
# 391 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define WINT_MIN (0U)
#endif
# 393 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/** Macros for minimum-width integer constant expressions */
#ifdef __INT8_C
#define INT8_C(x) __INT8_C(x)
#define UINT8_C(x) __UINT8_C(x)
#else
# 399 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT8_C(x)	x
#if 0 /* disabled by -frewrite-includes */
#if __STDINT_EXP(INT_MAX) > 0x7f
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 401 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define UINT8_C(x)	x
#else
# 403 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define UINT8_C(x)	x##U
#endif
# 405 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 406 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT16_C
#define INT16_C(x) __INT16_C(x)
#define UINT16_C(x) __UINT16_C(x)
#else
# 411 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT16_C(x)	x
#if 0 /* disabled by -frewrite-includes */
#if __STDINT_EXP(INT_MAX) > 0x7fff
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 413 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define UINT16_C(x)	x
#else
# 415 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define UINT16_C(x)	x##U
#endif
# 417 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 418 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT32_C
#define INT32_C(x) __INT32_C(x)
#define UINT32_C(x) __UINT32_C(x)
#else
# 423 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined (_INT32_EQ_LONG)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 424 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT32_C(x)	x##L
#define UINT32_C(x)	x##UL
#else
# 427 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT32_C(x)	x
#define UINT32_C(x)	x##U
#endif
# 430 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 431 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#ifdef __INT64_C
#define INT64_C(x) __INT64_C(x)
#define UINT64_C(x) __UINT64_C(x)
#else
# 436 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __int64_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 437 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __have_long64
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 438 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT64_C(x)	x##L
#define UINT64_C(x)	x##UL
#else
# 441 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INT64_C(x)	x##LL
#define UINT64_C(x)	x##ULL
#endif
# 444 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 445 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 446 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

/** Macros for greatest-width integer constant expression */
#ifdef __INTMAX_C
#define INTMAX_C(x) __INTMAX_C(x)
#define UINTMAX_C(x) __UINTMAX_C(x)
#else
# 452 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __have_long64
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 453 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INTMAX_C(x)	x##L
#define UINTMAX_C(x)	x##UL
#else
# 456 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#define INTMAX_C(x)	x##LL
#define UINTMAX_C(x)	x##ULL
#endif
# 459 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif
# 460 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3


#ifdef __cplusplus
}
#endif
# 465 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3

#endif /* _STDINT_H */
# 467 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdint.h" 3
#endif /* stdint.h expanded by -frewrite-includes */
# 57 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 2 3

# ifdef __STDC_LIMIT_MACROS_DEFINED_BY_CLANG
#  undef __STDC_LIMIT_MACROS
#  undef __STDC_LIMIT_MACROS_DEFINED_BY_CLANG
# endif
# 62 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# ifdef __STDC_CONSTANT_MACROS_DEFINED_BY_CLANG
#  undef __STDC_CONSTANT_MACROS
#  undef __STDC_CONSTANT_MACROS_DEFINED_BY_CLANG
# endif
# 66 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#else
# 68 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* C99 7.18.1.1 Exact-width integer types.
 * C99 7.18.1.2 Minimum-width integer types.
 * C99 7.18.1.3 Fastest minimum-width integer types.
 *
 * The standard requires that exact-width type be defined for 8-, 16-, 32-, and
 * 64-bit types if they are implemented. Other exact width types are optional.
 * This implementation defines an exact-width types for every integer width
 * that is represented in the standard integer types.
 *
 * The standard also requires minimum-width types be defined for 8-, 16-, 32-,
 * and 64-bit widths regardless of whether there are corresponding exact-width
 * types.
 *
 * To accommodate targets that are missing types that are exactly 8, 16, 32, or
 * 64 bits wide, this implementation takes an approach of cascading
 * redefinitions, redefining __int_leastN_t to successively smaller exact-width
 * types. It is therefore important that the types are defined in order of
 * descending widths.
 *
 * We currently assume that the minimum-width types and the fastest
 * minimum-width types are the same. This is allowed by the standard, but is
 * suboptimal.
 *
 * In violation of the standard, some targets do not implement a type that is
 * wide enough to represent all of the required widths (8-, 16-, 32-, 64-bit).
 * To accommodate these targets, a required minimum-width type is only
 * defined if there exists an exact-width type of equal or greater width.
 */

#ifdef __INT64_TYPE__
# ifndef __int8_t_defined /* glibc sys/types.h also defines int64_t*/
typedef __INT64_TYPE__ int64_t;
# endif /* __int8_t_defined */
# 102 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
typedef __UINT64_TYPE__ uint64_t;
# undef __int_least64_t
# define __int_least64_t int64_t
# undef __uint_least64_t
# define __uint_least64_t uint64_t
# undef __int_least32_t
# define __int_least32_t int64_t
# undef __uint_least32_t
# define __uint_least32_t uint64_t
# undef __int_least16_t
# define __int_least16_t int64_t
# undef __uint_least16_t
# define __uint_least16_t uint64_t
# undef __int_least8_t
# define __int_least8_t int64_t
# undef __uint_least8_t
# define __uint_least8_t uint64_t
#endif /* __INT64_TYPE__ */
# 120 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __int_least64_t
typedef __int_least64_t int_least64_t;
typedef __uint_least64_t uint_least64_t;
typedef __int_least64_t int_fast64_t;
typedef __uint_least64_t uint_fast64_t;
#endif /* __int_least64_t */
# 127 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT56_TYPE__
typedef __INT56_TYPE__ int56_t;
typedef __UINT56_TYPE__ uint56_t;
typedef int56_t int_least56_t;
typedef uint56_t uint_least56_t;
typedef int56_t int_fast56_t;
typedef uint56_t uint_fast56_t;
# undef __int_least32_t
# define __int_least32_t int56_t
# undef __uint_least32_t
# define __uint_least32_t uint56_t
# undef __int_least16_t
# define __int_least16_t int56_t
# undef __uint_least16_t
# define __uint_least16_t uint56_t
# undef __int_least8_t
# define __int_least8_t int56_t
# undef __uint_least8_t
# define __uint_least8_t uint56_t
#endif /* __INT56_TYPE__ */
# 148 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT48_TYPE__
typedef __INT48_TYPE__ int48_t;
typedef __UINT48_TYPE__ uint48_t;
typedef int48_t int_least48_t;
typedef uint48_t uint_least48_t;
typedef int48_t int_fast48_t;
typedef uint48_t uint_fast48_t;
# undef __int_least32_t
# define __int_least32_t int48_t
# undef __uint_least32_t
# define __uint_least32_t uint48_t
# undef __int_least16_t
# define __int_least16_t int48_t
# undef __uint_least16_t
# define __uint_least16_t uint48_t
# undef __int_least8_t
# define __int_least8_t int48_t
# undef __uint_least8_t
# define __uint_least8_t uint48_t
#endif /* __INT48_TYPE__ */
# 170 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT40_TYPE__
typedef __INT40_TYPE__ int40_t;
typedef __UINT40_TYPE__ uint40_t;
typedef int40_t int_least40_t;
typedef uint40_t uint_least40_t;
typedef int40_t int_fast40_t;
typedef uint40_t uint_fast40_t;
# undef __int_least32_t
# define __int_least32_t int40_t
# undef __uint_least32_t
# define __uint_least32_t uint40_t
# undef __int_least16_t
# define __int_least16_t int40_t
# undef __uint_least16_t
# define __uint_least16_t uint40_t
# undef __int_least8_t
# define __int_least8_t int40_t
# undef __uint_least8_t
# define __uint_least8_t uint40_t
#endif /* __INT40_TYPE__ */
# 192 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT32_TYPE__

# ifndef __int8_t_defined /* glibc sys/types.h also defines int32_t*/
typedef __INT32_TYPE__ int32_t;
# endif /* __int8_t_defined */
# 199 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

# ifndef __uint32_t_defined  /* more glibc compatibility */
# define __uint32_t_defined
typedef __UINT32_TYPE__ uint32_t;
# endif /* __uint32_t_defined */
# 204 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

# undef __int_least32_t
# define __int_least32_t int32_t
# undef __uint_least32_t
# define __uint_least32_t uint32_t
# undef __int_least16_t
# define __int_least16_t int32_t
# undef __uint_least16_t
# define __uint_least16_t uint32_t
# undef __int_least8_t
# define __int_least8_t int32_t
# undef __uint_least8_t
# define __uint_least8_t uint32_t
#endif /* __INT32_TYPE__ */
# 218 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __int_least32_t
typedef __int_least32_t int_least32_t;
typedef __uint_least32_t uint_least32_t;
typedef __int_least32_t int_fast32_t;
typedef __uint_least32_t uint_fast32_t;
#endif /* __int_least32_t */
# 225 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT24_TYPE__
typedef __INT24_TYPE__ int24_t;
typedef __UINT24_TYPE__ uint24_t;
typedef int24_t int_least24_t;
typedef uint24_t uint_least24_t;
typedef int24_t int_fast24_t;
typedef uint24_t uint_fast24_t;
# undef __int_least16_t
# define __int_least16_t int24_t
# undef __uint_least16_t
# define __uint_least16_t uint24_t
# undef __int_least8_t
# define __int_least8_t int24_t
# undef __uint_least8_t
# define __uint_least8_t uint24_t
#endif /* __INT24_TYPE__ */
# 242 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT16_TYPE__
#ifndef __int8_t_defined /* glibc sys/types.h also defines int16_t*/
typedef __INT16_TYPE__ int16_t;
#endif /* __int8_t_defined */
# 247 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
typedef __UINT16_TYPE__ uint16_t;
# undef __int_least16_t
# define __int_least16_t int16_t
# undef __uint_least16_t
# define __uint_least16_t uint16_t
# undef __int_least8_t
# define __int_least8_t int16_t
# undef __uint_least8_t
# define __uint_least8_t uint16_t
#endif /* __INT16_TYPE__ */
# 257 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __int_least16_t
typedef __int_least16_t int_least16_t;
typedef __uint_least16_t uint_least16_t;
typedef __int_least16_t int_fast16_t;
typedef __uint_least16_t uint_fast16_t;
#endif /* __int_least16_t */
# 264 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT8_TYPE__
#ifndef __int8_t_defined  /* glibc sys/types.h also defines int8_t*/
typedef __INT8_TYPE__ int8_t;
#endif /* __int8_t_defined */
# 270 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
typedef __UINT8_TYPE__ uint8_t;
# undef __int_least8_t
# define __int_least8_t int8_t
# undef __uint_least8_t
# define __uint_least8_t uint8_t
#endif /* __INT8_TYPE__ */
# 276 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __int_least8_t
typedef __int_least8_t int_least8_t;
typedef __uint_least8_t uint_least8_t;
typedef __int_least8_t int_fast8_t;
typedef __uint_least8_t uint_fast8_t;
#endif /* __int_least8_t */
# 283 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* prevent glibc sys/types.h from defining conflicting types */
#ifndef __int8_t_defined
# define __int8_t_defined
#endif /* __int8_t_defined */
# 288 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* C99 7.18.1.4 Integer types capable of holding object pointers.
 */
#define __stdint_join3(a,b,c) a ## b ## c

#ifndef _INTPTR_T
#ifndef __intptr_t_defined
typedef __INTPTR_TYPE__ intptr_t;
#define __intptr_t_defined
#define _INTPTR_T
#endif
# 299 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif
# 300 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifndef _UINTPTR_T
typedef __UINTPTR_TYPE__ uintptr_t;
#define _UINTPTR_T
#endif
# 305 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* C99 7.18.1.5 Greatest-width integer types.
 */
typedef __INTMAX_TYPE__  intmax_t;
typedef __UINTMAX_TYPE__ uintmax_t;

/* C99 7.18.4 Macros for minimum-width integer constants.
 *
 * The standard requires that integer constant macros be defined for all the
 * minimum-width types defined above. As 8-, 16-, 32-, and 64-bit minimum-width
 * types are required, the corresponding integer constant macros are defined
 * here. This implementation also defines minimum-width types for every other
 * integer width that the target implements, so corresponding macros are
 * defined below, too.
 *
 * Note that C++ should not check __STDC_CONSTANT_MACROS here, contrary to the
 * claims of the C standard (see C++ 18.3.1p2, [cstdint.syn]).
 */

#ifdef __int_least64_t
#define INT64_C(v) __INT64_C(v)
#define UINT64_C(v) __UINT64_C(v)
#endif /* __int_least64_t */
# 328 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT56_TYPE__
#define INT56_C(v) __INT56_C(v)
#define UINT56_C(v) __UINT56_C(v)
#endif /* __INT56_TYPE__ */
# 334 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT48_TYPE__
#define INT48_C(v) __INT48_C(v)
#define UINT48_C(v) __UINT48_C(v)
#endif /* __INT48_TYPE__ */
# 340 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT40_TYPE__
#define INT40_C(v) __INT40_C(v)
#define UINT40_C(v) __UINT40_C(v)
#endif /* __INT40_TYPE__ */
# 346 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __int_least32_t
#define INT32_C(v) __INT32_C(v)
#define UINT32_C(v) __UINT32_C(v)
#endif /* __int_least32_t */
# 352 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT24_TYPE__
#define INT24_C(v) __INT24_C(v)
#define UINT24_C(v) __UINT24_C(v)
#endif /* __INT24_TYPE__ */
# 358 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __int_least16_t
#define INT16_C(v) __INT16_C(v)
#define UINT16_C(v) __UINT16_C(v)
#endif /* __int_least16_t */
# 364 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __int_least8_t
#define INT8_C(v) __INT8_C(v)
#define UINT8_C(v) __UINT8_C(v)
#endif /* __int_least8_t */
# 370 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


/* C99 7.18.2.1 Limits of exact-width integer types.
 * C99 7.18.2.2 Limits of minimum-width integer types.
 * C99 7.18.2.3 Limits of fastest minimum-width integer types.
 *
 * The presence of limit macros are completely optional in C99.  This
 * implementation defines limits for all of the types (exact- and
 * minimum-width) that it defines above, using the limits of the minimum-width
 * type for any types that do not have exact-width representations.
 *
 * As in the type definitions, this section takes an approach of
 * successive-shrinking to determine which limits to use for the standard (8,
 * 16, 32, 64) bit widths when they don't have exact representations. It is
 * therefore important that the definitions be kept in order of decending
 * widths.
 *
 * Note that C++ should not check __STDC_LIMIT_MACROS here, contrary to the
 * claims of the C standard (see C++ 18.3.1p2, [cstdint.syn]).
 */

#ifdef __INT64_TYPE__
# define INT64_MAX           INT64_C( 9223372036854775807)
# define INT64_MIN         (-INT64_C( 9223372036854775807)-1)
# define UINT64_MAX         UINT64_C(18446744073709551615)

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 397 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT64_WIDTH         64
# define INT64_WIDTH          UINT64_WIDTH

# define __UINT_LEAST64_WIDTH UINT64_WIDTH
# undef __UINT_LEAST32_WIDTH
# define __UINT_LEAST32_WIDTH UINT64_WIDTH
# undef __UINT_LEAST16_WIDTH
# define __UINT_LEAST16_WIDTH UINT64_WIDTH
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX UINT64_MAX
#endif /* __STDC_VERSION__ */
# 408 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

# define __INT_LEAST64_MIN   INT64_MIN
# define __INT_LEAST64_MAX   INT64_MAX
# define __UINT_LEAST64_MAX UINT64_MAX
# undef __INT_LEAST32_MIN
# define __INT_LEAST32_MIN   INT64_MIN
# undef __INT_LEAST32_MAX
# define __INT_LEAST32_MAX   INT64_MAX
# undef __UINT_LEAST32_MAX
# define __UINT_LEAST32_MAX UINT64_MAX
# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT64_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT64_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT64_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT64_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT64_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT64_MAX
#endif /* __INT64_TYPE__ */
# 431 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT_LEAST64_MIN
# define INT_LEAST64_MIN   __INT_LEAST64_MIN
# define INT_LEAST64_MAX   __INT_LEAST64_MAX
# define UINT_LEAST64_MAX __UINT_LEAST64_MAX
# define INT_FAST64_MIN    __INT_LEAST64_MIN
# define INT_FAST64_MAX    __INT_LEAST64_MAX
# define UINT_FAST64_MAX  __UINT_LEAST64_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) &&  __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 441 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT_LEAST64_WIDTH __UINT_LEAST64_WIDTH
# define INT_LEAST64_WIDTH  UINT_LEAST64_WIDTH
# define UINT_FAST64_WIDTH  __UINT_LEAST64_WIDTH
# define INT_FAST64_WIDTH   UINT_FAST64_WIDTH
#endif /* __STDC_VERSION__ */
# 446 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT_LEAST64_MIN */
# 447 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT56_TYPE__
# define INT56_MAX           INT56_C(36028797018963967)
# define INT56_MIN         (-INT56_C(36028797018963967)-1)
# define UINT56_MAX         UINT56_C(72057594037927935)
# define INT_LEAST56_MIN     INT56_MIN
# define INT_LEAST56_MAX     INT56_MAX
# define UINT_LEAST56_MAX   UINT56_MAX
# define INT_FAST56_MIN      INT56_MIN
# define INT_FAST56_MAX      INT56_MAX
# define UINT_FAST56_MAX    UINT56_MAX

# undef __INT_LEAST32_MIN
# define __INT_LEAST32_MIN   INT56_MIN
# undef __INT_LEAST32_MAX
# define __INT_LEAST32_MAX   INT56_MAX
# undef __UINT_LEAST32_MAX
# define __UINT_LEAST32_MAX UINT56_MAX
# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT56_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT56_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT56_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT56_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT56_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT56_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 480 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT56_WIDTH         56
# define INT56_WIDTH          UINT56_WIDTH
# define UINT_LEAST56_WIDTH   UINT56_WIDTH
# define INT_LEAST56_WIDTH    UINT_LEAST56_WIDTH
# define UINT_FAST56_WIDTH    UINT56_WIDTH
# define INT_FAST56_WIDTH     UINT_FAST56_WIDTH
# undef __UINT_LEAST32_WIDTH
# define __UINT_LEAST32_WIDTH UINT56_WIDTH
# undef __UINT_LEAST16_WIDTH
# define __UINT_LEAST16_WIDTH UINT56_WIDTH
# undef __UINT_LEAST8_WIDTH
# define __UINT_LEAST8_WIDTH  UINT56_WIDTH
#endif /* __STDC_VERSION__ */
# 493 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT56_TYPE__ */
# 494 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT48_TYPE__
# define INT48_MAX           INT48_C(140737488355327)
# define INT48_MIN         (-INT48_C(140737488355327)-1)
# define UINT48_MAX         UINT48_C(281474976710655)
# define INT_LEAST48_MIN     INT48_MIN
# define INT_LEAST48_MAX     INT48_MAX
# define UINT_LEAST48_MAX   UINT48_MAX
# define INT_FAST48_MIN      INT48_MIN
# define INT_FAST48_MAX      INT48_MAX
# define UINT_FAST48_MAX    UINT48_MAX

# undef __INT_LEAST32_MIN
# define __INT_LEAST32_MIN   INT48_MIN
# undef __INT_LEAST32_MAX
# define __INT_LEAST32_MAX   INT48_MAX
# undef __UINT_LEAST32_MAX
# define __UINT_LEAST32_MAX UINT48_MAX
# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT48_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT48_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT48_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT48_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT48_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT48_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 527 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#define UINT48_WIDTH         48
#define INT48_WIDTH          UINT48_WIDTH
#define UINT_LEAST48_WIDTH   UINT48_WIDTH
#define INT_LEAST48_WIDTH    UINT_LEAST48_WIDTH
#define UINT_FAST48_WIDTH    UINT48_WIDTH
#define INT_FAST48_WIDTH     UINT_FAST48_WIDTH
#undef __UINT_LEAST32_WIDTH
#define __UINT_LEAST32_WIDTH UINT48_WIDTH
# undef __UINT_LEAST16_WIDTH
#define __UINT_LEAST16_WIDTH UINT48_WIDTH
# undef __UINT_LEAST8_WIDTH
#define __UINT_LEAST8_WIDTH  UINT48_WIDTH
#endif /* __STDC_VERSION__ */
# 540 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT48_TYPE__ */
# 541 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT40_TYPE__
# define INT40_MAX           INT40_C(549755813887)
# define INT40_MIN         (-INT40_C(549755813887)-1)
# define UINT40_MAX         UINT40_C(1099511627775)
# define INT_LEAST40_MIN     INT40_MIN
# define INT_LEAST40_MAX     INT40_MAX
# define UINT_LEAST40_MAX   UINT40_MAX
# define INT_FAST40_MIN      INT40_MIN
# define INT_FAST40_MAX      INT40_MAX
# define UINT_FAST40_MAX    UINT40_MAX

# undef __INT_LEAST32_MIN
# define __INT_LEAST32_MIN   INT40_MIN
# undef __INT_LEAST32_MAX
# define __INT_LEAST32_MAX   INT40_MAX
# undef __UINT_LEAST32_MAX
# define __UINT_LEAST32_MAX UINT40_MAX
# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT40_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT40_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT40_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT40_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT40_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT40_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 574 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT40_WIDTH         40
# define INT40_WIDTH          UINT40_WIDTH
# define UINT_LEAST40_WIDTH   UINT40_WIDTH
# define INT_LEAST40_WIDTH    UINT_LEAST40_WIDTH
# define UINT_FAST40_WIDTH    UINT40_WIDTH
# define INT_FAST40_WIDTH     UINT_FAST40_WIDTH
# undef __UINT_LEAST32_WIDTH
# define __UINT_LEAST32_WIDTH UINT40_WIDTH
# undef __UINT_LEAST16_WIDTH
# define __UINT_LEAST16_WIDTH UINT40_WIDTH
# undef __UINT_LEAST8_WIDTH
# define __UINT_LEAST8_WIDTH  UINT40_WIDTH
#endif /* __STDC_VERSION__ */
# 587 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT40_TYPE__ */
# 588 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT32_TYPE__
# define INT32_MAX           INT32_C(2147483647)
# define INT32_MIN         (-INT32_C(2147483647)-1)
# define UINT32_MAX         UINT32_C(4294967295)

# undef __INT_LEAST32_MIN
# define __INT_LEAST32_MIN   INT32_MIN
# undef __INT_LEAST32_MAX
# define __INT_LEAST32_MAX   INT32_MAX
# undef __UINT_LEAST32_MAX
# define __UINT_LEAST32_MAX UINT32_MAX
# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT32_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT32_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT32_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT32_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT32_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT32_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 615 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT32_WIDTH         32
# define INT32_WIDTH          UINT32_WIDTH
# undef __UINT_LEAST32_WIDTH
# define __UINT_LEAST32_WIDTH UINT32_WIDTH
# undef __UINT_LEAST16_WIDTH
# define __UINT_LEAST16_WIDTH UINT32_WIDTH
# undef __UINT_LEAST8_WIDTH
# define __UINT_LEAST8_WIDTH  UINT32_WIDTH
#endif /* __STDC_VERSION__ */
# 624 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT32_TYPE__ */
# 625 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT_LEAST32_MIN
# define INT_LEAST32_MIN   __INT_LEAST32_MIN
# define INT_LEAST32_MAX   __INT_LEAST32_MAX
# define UINT_LEAST32_MAX __UINT_LEAST32_MAX
# define INT_FAST32_MIN    __INT_LEAST32_MIN
# define INT_FAST32_MAX    __INT_LEAST32_MAX
# define UINT_FAST32_MAX  __UINT_LEAST32_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 635 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT_LEAST32_WIDTH __UINT_LEAST32_WIDTH
# define INT_LEAST32_WIDTH  UINT_LEAST32_WIDTH
# define UINT_FAST32_WIDTH  __UINT_LEAST32_WIDTH
# define INT_FAST32_WIDTH   UINT_FAST32_WIDTH
#endif /* __STDC_VERSION__ */
# 640 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT_LEAST32_MIN */
# 641 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT24_TYPE__
# define INT24_MAX           INT24_C(8388607)
# define INT24_MIN         (-INT24_C(8388607)-1)
# define UINT24_MAX         UINT24_C(16777215)
# define INT_LEAST24_MIN     INT24_MIN
# define INT_LEAST24_MAX     INT24_MAX
# define UINT_LEAST24_MAX   UINT24_MAX
# define INT_FAST24_MIN      INT24_MIN
# define INT_FAST24_MAX      INT24_MAX
# define UINT_FAST24_MAX    UINT24_MAX

# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT24_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT24_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT24_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT24_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT24_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT24_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 668 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT24_WIDTH         24
# define INT24_WIDTH          UINT24_WIDTH
# define UINT_LEAST24_WIDTH   UINT24_WIDTH
# define INT_LEAST24_WIDTH    UINT_LEAST24_WIDTH
# define UINT_FAST24_WIDTH    UINT24_WIDTH
# define INT_FAST24_WIDTH     UINT_FAST24_WIDTH
# undef __UINT_LEAST16_WIDTH
# define __UINT_LEAST16_WIDTH UINT24_WIDTH
# undef __UINT_LEAST8_WIDTH
# define __UINT_LEAST8_WIDTH  UINT24_WIDTH
#endif /* __STDC_VERSION__ */
# 679 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT24_TYPE__ */
# 680 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT16_TYPE__
#define INT16_MAX            INT16_C(32767)
#define INT16_MIN          (-INT16_C(32767)-1)
#define UINT16_MAX          UINT16_C(65535)

# undef __INT_LEAST16_MIN
# define __INT_LEAST16_MIN   INT16_MIN
# undef __INT_LEAST16_MAX
# define __INT_LEAST16_MAX   INT16_MAX
# undef __UINT_LEAST16_MAX
# define __UINT_LEAST16_MAX UINT16_MAX
# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT16_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT16_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT16_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 701 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT16_WIDTH         16
# define INT16_WIDTH          UINT16_WIDTH
# undef __UINT_LEAST16_WIDTH
# define __UINT_LEAST16_WIDTH UINT16_WIDTH
# undef __UINT_LEAST8_WIDTH
# define __UINT_LEAST8_WIDTH  UINT16_WIDTH
#endif /* __STDC_VERSION__ */
# 708 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT16_TYPE__ */
# 709 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT_LEAST16_MIN
# define INT_LEAST16_MIN   __INT_LEAST16_MIN
# define INT_LEAST16_MAX   __INT_LEAST16_MAX
# define UINT_LEAST16_MAX __UINT_LEAST16_MAX
# define INT_FAST16_MIN    __INT_LEAST16_MIN
# define INT_FAST16_MAX    __INT_LEAST16_MAX
# define UINT_FAST16_MAX  __UINT_LEAST16_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 719 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT_LEAST16_WIDTH __UINT_LEAST16_WIDTH
# define INT_LEAST16_WIDTH  UINT_LEAST16_WIDTH
# define UINT_FAST16_WIDTH  __UINT_LEAST16_WIDTH
# define INT_FAST16_WIDTH   UINT_FAST16_WIDTH
#endif /* __STDC_VERSION__ */
# 724 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT_LEAST16_MIN */
# 725 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3


#ifdef __INT8_TYPE__
# define INT8_MAX            INT8_C(127)
# define INT8_MIN          (-INT8_C(127)-1)
# define UINT8_MAX          UINT8_C(255)

# undef __INT_LEAST8_MIN
# define __INT_LEAST8_MIN    INT8_MIN
# undef __INT_LEAST8_MAX
# define __INT_LEAST8_MAX    INT8_MAX
# undef __UINT_LEAST8_MAX
# define __UINT_LEAST8_MAX  UINT8_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 740 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT8_WIDTH         8
# define INT8_WIDTH          UINT8_WIDTH
# undef __UINT_LEAST8_WIDTH
# define __UINT_LEAST8_WIDTH UINT8_WIDTH
#endif /* __STDC_VERSION__ */
# 745 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT8_TYPE__ */
# 746 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifdef __INT_LEAST8_MIN
# define INT_LEAST8_MIN   __INT_LEAST8_MIN
# define INT_LEAST8_MAX   __INT_LEAST8_MAX
# define UINT_LEAST8_MAX __UINT_LEAST8_MAX
# define INT_FAST8_MIN    __INT_LEAST8_MIN
# define INT_FAST8_MAX    __INT_LEAST8_MAX
# define UINT_FAST8_MAX  __UINT_LEAST8_MAX

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 756 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define UINT_LEAST8_WIDTH __UINT_LEAST8_WIDTH
# define INT_LEAST8_WIDTH  UINT_LEAST8_WIDTH
# define UINT_FAST8_WIDTH  __UINT_LEAST8_WIDTH
# define INT_FAST8_WIDTH   UINT_FAST8_WIDTH
#endif /* __STDC_VERSION__ */
# 761 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __INT_LEAST8_MIN */
# 762 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* Some utility macros */
#define  __INTN_MIN(n)  __stdint_join3( INT, n, _MIN)
#define  __INTN_MAX(n)  __stdint_join3( INT, n, _MAX)
#define __UINTN_MAX(n)  __stdint_join3(UINT, n, _MAX)
#define  __INTN_C(n, v) __stdint_join3( INT, n, _C(v))
#define __UINTN_C(n, v) __stdint_join3(UINT, n, _C(v))

/* C99 7.18.2.4 Limits of integer types capable of holding object pointers. */
/* C99 7.18.3 Limits of other integer types. */

#define  INTPTR_MIN  (-__INTPTR_MAX__-1)
#define  INTPTR_MAX    __INTPTR_MAX__
#define UINTPTR_MAX   __UINTPTR_MAX__
#define PTRDIFF_MIN (-__PTRDIFF_MAX__-1)
#define PTRDIFF_MAX   __PTRDIFF_MAX__
#define    SIZE_MAX      __SIZE_MAX__

/* C23 7.22.2.4 Width of integer types capable of holding object pointers. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 782 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
/* NB: The C standard requires that these be the same value, but the compiler
   exposes separate internal width macros. */
#define INTPTR_WIDTH  __INTPTR_WIDTH__
#define UINTPTR_WIDTH __UINTPTR_WIDTH__
#endif
# 787 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* ISO9899:2011 7.20 (C11 Annex K): Define RSIZE_MAX if __STDC_WANT_LIB_EXT1__
 * is enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 791 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#define   RSIZE_MAX            (SIZE_MAX >> 1)
#endif
# 793 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* C99 7.18.2.5 Limits of greatest-width integer types. */
#define  INTMAX_MIN (-__INTMAX_MAX__-1)
#define  INTMAX_MAX   __INTMAX_MAX__
#define UINTMAX_MAX  __UINTMAX_MAX__

/* C23 7.22.2.5 Width of greatest-width integer types. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 801 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
/* NB: The C standard requires that these be the same value, but the compiler
   exposes separate internal width macros. */
#define INTMAX_WIDTH __INTMAX_WIDTH__
#define UINTMAX_WIDTH __UINTMAX_WIDTH__
#endif
# 806 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* C99 7.18.3 Limits of other integer types. */
#define SIG_ATOMIC_MIN __INTN_MIN(__SIG_ATOMIC_WIDTH__)
#define SIG_ATOMIC_MAX __INTN_MAX(__SIG_ATOMIC_WIDTH__)
#ifdef __WINT_UNSIGNED__
# define WINT_MIN       __UINTN_C(__WINT_WIDTH__, 0)
# define WINT_MAX       __UINTN_MAX(__WINT_WIDTH__)
#else
# 814 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
# define WINT_MIN       __INTN_MIN(__WINT_WIDTH__)
# define WINT_MAX       __INTN_MAX(__WINT_WIDTH__)
#endif
# 817 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#ifndef WCHAR_MAX
# define WCHAR_MAX __WCHAR_MAX__
#endif
# 821 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#ifndef WCHAR_MIN
#if 0 /* disabled by -frewrite-includes */
# if __WCHAR_MAX__ == __INTN_MAX(__WCHAR_WIDTH__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 823 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#  define WCHAR_MIN __INTN_MIN(__WCHAR_WIDTH__)
# else
# 825 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#  define WCHAR_MIN __UINTN_C(__WCHAR_WIDTH__, 0)
# endif
# 827 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif
# 828 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

/* 7.18.4.2 Macros for greatest-width integer constants. */
#define  INTMAX_C(v) __INTMAX_C(v)
#define UINTMAX_C(v) __UINTMAX_C(v)

/* C23 7.22.3.x Width of other integer types. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 835 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#define PTRDIFF_WIDTH    __PTRDIFF_WIDTH__
#define SIG_ATOMIC_WIDTH __SIG_ATOMIC_WIDTH__
#define SIZE_WIDTH       __SIZE_WIDTH__
#define WCHAR_WIDTH      __WCHAR_WIDTH__
#define WINT_WIDTH       __WINT_WIDTH__
#endif
# 841 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3

#endif /* __STDC_HOSTED__ */
# 843 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __MVS__ */
# 844 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* __CLANG_STDINT_H */
# 845 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdint.h" 3
#endif /* stdint.h expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h" 2
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stddef.h expanded by -frewrite-includes */
#include <stddef.h>
#else /* stddef.h expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 1 3
/*===---- stddef.h - Basic type definitions --------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stddef.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stddef.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#undef __need_size_t
#undef __need_rsize_t
#undef __need_wchar_t
#undef __need_NULL
#undef __need_nullptr_t
#undef __need_unreachable
#undef __need_max_align_t
#undef __need_offsetof
#undef __need_wint_t
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stddef.h>
#endif /* expanded by -frewrite-includes */
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#else
# 37 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__need_ptrdiff_t) && !defined(__need_size_t) &&                   \
    !defined(__need_rsize_t) && !defined(__need_wchar_t) &&                    \
    !defined(__need_NULL) && !defined(__need_nullptr_t) &&                     \
    !defined(__need_unreachable) && !defined(__need_max_align_t) &&            \
    !defined(__need_offsetof) && !defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 43 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_ptrdiff_t
#define __need_size_t
/* ISO9899:2011 7.20 (C11 Annex K): Define rsize_t if __STDC_WANT_LIB_EXT1__ is
 * enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_rsize_t
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_wchar_t
#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDDEF_H) || __has_feature(modules)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
/*
 * __stddef_null.h is special when building without modules: if __need_NULL is
 * set, then it will unconditionally redefine NULL. To avoid stepping on client
 * definitions of NULL, __need_NULL should only be set the first time this
 * header is included, that is when __STDDEF_H is not defined. However, when
 * building with modules, this header is a textual header and needs to
 * unconditionally include __stdef_null.h to support multiple submodules
 * exporting _Builtin_stddef.null. Take module SM with submodules A and B, whose
 * headers both include stddef.h When SM.A builds, __STDDEF_H will be defined.
 * When SM.B builds, the definition from SM.A will leak when building without
 * local submodule visibility. stddef.h wouldn't include __stddef_null.h, and
 * SM.B wouldn't import _Builtin_stddef.null, and SM.B's `export *` wouldn't
 * export NULL as expected. When building with modules, always include
 * __stddef_null.h so that everything works as expected.
 */
#define __need_NULL
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) ||              \
    defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_nullptr_t
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_unreachable
#endif
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 78 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_max_align_t
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_offsetof
/* wint_t is provided by <wchar.h> and not <stddef.h>. It's here
 * for compatibility, but must be explicitly requested. Therefore
 * __need_wint_t is intentionally not defined here. */
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_header_macro.h expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#else /* __stddef_header_macro.h expanded by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_header_macro.h" 1 3
/*===---- __stddef_header_macro.h ------------------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __STDDEF_H
#define __STDDEF_H
#endif
# 13 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_header_macro.h" 3
#endif /* __stddef_header_macro.h expanded by -frewrite-includes */
# 85 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_ptrdiff_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
#include <__stddef_ptrdiff_t.h>
#else /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 1 3
/*===---- __stddef_ptrdiff_t.h - Definition of ptrdiff_t -------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_PTRDIFF_T) ||                                                    \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 3
#define _PTRDIFF_T

typedef __PTRDIFF_TYPE__ ptrdiff_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 3
#endif /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
# 89 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_ptrdiff_t
#endif /* defined(__need_ptrdiff_t) */
# 91 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_size_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_size_t.h expanded by -frewrite-includes */
#include <__stddef_size_t.h>
#else /* __stddef_size_t.h expanded by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 1 3
/*===---- __stddef_size_t.h - Definition of size_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_SIZE_T) ||                                                       \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#define _SIZE_T

typedef __SIZE_TYPE__ size_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#endif /* __stddef_size_t.h expanded by -frewrite-includes */
# 94 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_size_t
#endif /*defined(__need_size_t) */
# 96 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_rsize_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_rsize_t.h>
#endif /* expanded by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_rsize_t
#endif /* defined(__need_rsize_t) */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wchar_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_wchar_t.h expanded by -frewrite-includes */
#include <__stddef_wchar_t.h>
#else /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 1 3
/*===---- __stddef_wchar.h - Definition of wchar_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(__cplusplus) || (defined(_MSC_VER) && !_NATIVE_WCHAR_T_DEFINED)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_WCHAR_T) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#define _WCHAR_T

#ifdef _MSC_EXTENSIONS
#define _WCHAR_T_DEFINED
#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

typedef __WCHAR_TYPE__ wchar_t;

#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

#endif
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#endif /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_wchar_t
#endif /* defined(__need_wchar_t) */
# 106 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_NULL)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_null.h expanded by -frewrite-includes */
#include <__stddef_null.h>
#else /* __stddef_null.h expanded by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 1 3
/*===---- __stddef_null.h - Definition of NULL -----------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(NULL) || !__building_module(_Builtin_stddef)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3

/* linux/stddef.h will define NULL to 0. glibc (and other) headers then define
 * __need_NULL and rely on stddef.h to redefine NULL to the correct value again.
 * Modules don't support redefining macros like that, but support that pattern
 * in the non-modules case.
 */
#undef NULL

#ifdef __cplusplus
#if 0 /* disabled by -frewrite-includes */
#if !defined(__MINGW32__) && !defined(_MSC_VER)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#define NULL __null
#else
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#define NULL 0
#endif
# 25 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#else
# 26 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#define NULL ((void*)0)
#endif
# 28 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3

#endif
# 30 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#endif /* __stddef_null.h expanded by -frewrite-includes */
# 109 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_NULL
#endif /* defined(__need_NULL) */
# 111 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_nullptr_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_nullptr_t.h>
#endif /* expanded by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 114 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_nullptr_t
#endif /* defined(__need_nullptr_t) */
# 116 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_unreachable.h>
#endif /* expanded by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 119 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_unreachable
#endif /* defined(__need_unreachable) */
# 121 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_max_align_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_max_align_t.h expanded by -frewrite-includes */
#include <__stddef_max_align_t.h>
#else /* __stddef_max_align_t.h expanded by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_max_align_t.h" 1 3
/*===---- __stddef_max_align_t.h - Definition of max_align_t ---------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __CLANG_MAX_ALIGN_T_DEFINED
#define __CLANG_MAX_ALIGN_T_DEFINED

#if 0 /* disabled by -frewrite-includes */
#if defined(_MSC_VER)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_max_align_t.h" 3
typedef double max_align_t;
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__APPLE__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_max_align_t.h" 3
typedef long double max_align_t;
#else
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_max_align_t.h" 3
// Define 'max_align_t' to match the GCC definition.
typedef struct {
  long long __clang_max_align_nonce1
      __attribute__((__aligned__(__alignof__(long long))));
  long double __clang_max_align_nonce2
      __attribute__((__aligned__(__alignof__(long double))));
} max_align_t;
#endif
# 26 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_max_align_t.h" 3

#endif
# 28 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_max_align_t.h" 3
#endif /* __stddef_max_align_t.h expanded by -frewrite-includes */
# 124 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_max_align_t
#endif /* defined(__need_max_align_t) */
# 126 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_offsetof)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_offsetof.h expanded by -frewrite-includes */
#include <__stddef_offsetof.h>
#else /* __stddef_offsetof.h expanded by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 1 3
/*===---- __stddef_offsetof.h - Definition of offsetof ---------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(offsetof) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 3
#define offsetof(t, d) __builtin_offsetof(t, d)
#endif
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 3
#endif /* __stddef_offsetof.h expanded by -frewrite-includes */
# 129 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_offsetof
#endif /* defined(__need_offsetof) */
# 131 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

/* Some C libraries expect to see a wint_t here. Others (notably MinGW) will use
__WINT_TYPE__ directly; accommodate both by requiring __need_wint_t */
#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wint_t.h>
#endif /* expanded by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 136 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wint_t
#endif /* __need_wint_t */
# 138 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#endif /* __MVS__ */
# 140 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif /* stddef.h expanded by -frewrite-includes */
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h" 2
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* inttypes.h expanded by -frewrite-includes */
#include <inttypes.h>
#else /* inttypes.h expanded by -frewrite-includes */
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 1 3
/*===---- inttypes.h - Standard header for integer printf macros ----------===*\
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
\*===----------------------------------------------------------------------===*/

#ifndef __CLANG_INTTYPES_H
// AIX system headers need inttypes.h to be re-enterable while _STD_TYPES_T
// is defined until an inclusion of it without _STD_TYPES_T occurs, in which
// case the header guard macro is defined.
#if 0 /* disabled by -frewrite-includes */
#if !defined(_AIX) || !defined(_STD_TYPES_T)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#define __CLANG_INTTYPES_H
#endif
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<inttypes.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <inttypes.h>
#endif /* expanded by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#else
# 19 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_MSC_VER) && _MSC_VER < 1800
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#error MSVC does not have inttypes.h prior to Visual Studio 2013
#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* inttypes.h expanded by -frewrite-includes */
#include_next <inttypes.h>
#else /* inttypes.h expanded by -frewrite-includes */
# 24 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 1 3
/*
 * Copyright (c) 2004, 2005 by
 * Ralf Corsepius, Ulm/Germany. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

/**
 *  @file  inttypes.h
 */

#ifndef _INTTYPES_H
#define _INTTYPES_H

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* newlib.h expanded by -frewrite-includes */
#include <newlib.h>
#else /* newlib.h expanded by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/newlib.h" 1 3
/* newlib.h.  Generated from newlib.hin by configure.  */
/* newlib.hin.  Generated from configure.ac by autoheader.  */

/* NB: The contents are filtered before being installed. */

#ifndef __NEWLIB_H__
#define __NEWLIB_H__ 1

/* Newlib version */
#if 0 /* expanded by -frewrite-includes */
#include <_newlib_version.h>
#endif /* expanded by -frewrite-includes */
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/newlib.h" 3
# 11 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/newlib.h" 3

/* Define to 1 if the system has the type `long double'. */

/* Define to the address where bug reports for this package should be sent. */

/* Define to the full name of this package. */

/* Define to the full name and version of this package. */

/* Define to the one symbol short name of this package. */

/* Define to the home page for this package. */

/* Define to the version of this package. */

/* If atexit() may dynamically allocate space for cleanup functions. */
/* #undef _ATEXIT_DYNAMIC_ALLOC */

/* EL/IX level */
/* #undef _ELIX_LEVEL */

/* Define if fseek functions support seek optimization. */
#define _FSEEK_OPTIMIZATION 1

/* Define if ivo supported in streamio. */
#define _FVWRITE_IN_STREAMIO 1

/* Define if compiler supports -fno-tree-loop-distribute-patterns. */
#define _HAVE_CC_INHIBIT_LOOP_TO_LIBCALL 1

/* Define if the linker supports .preinit_array/.init_array/.fini_array
   sections. */
#define _HAVE_INITFINI_ARRAY 1

/* Define if the platform supports long double type. */
#define _HAVE_LONG_DOUBLE 1

/* ICONV enabled. */
/* #undef _ICONV_ENABLED */

/* Enable ICONV external CCS files loading capabilities. */
/* #undef _ICONV_ENABLE_EXTERNAL_CCS */

/* Support big5 input encoding. */
/* #undef _ICONV_FROM_ENCODING_BIG5 */

/* Support cp775 input encoding. */
/* #undef _ICONV_FROM_ENCODING_CP775 */

/* Support cp850 input encoding. */
/* #undef _ICONV_FROM_ENCODING_CP850 */

/* Support cp852 input encoding. */
/* #undef _ICONV_FROM_ENCODING_CP852 */

/* Support cp855 input encoding. */
/* #undef _ICONV_FROM_ENCODING_CP855 */

/* Support cp866 input encoding. */
/* #undef _ICONV_FROM_ENCODING_CP866 */

/* Support euc_jp input encoding. */
/* #undef _ICONV_FROM_ENCODING_EUC_JP */

/* Support euc_kr input encoding. */
/* #undef _ICONV_FROM_ENCODING_EUC_KR */

/* Support euc_tw input encoding. */
/* #undef _ICONV_FROM_ENCODING_EUC_TW */

/* Support iso_8859_1 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_1 */

/* Support iso_8859_10 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_10 */

/* Support iso_8859_11 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_11 */

/* Support iso_8859_13 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_13 */

/* Support iso_8859_14 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_14 */

/* Support iso_8859_15 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_15 */

/* Support iso_8859_2 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_2 */

/* Support iso_8859_3 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_3 */

/* Support iso_8859_4 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_4 */

/* Support iso_8859_5 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_5 */

/* Support iso_8859_6 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_6 */

/* Support iso_8859_7 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_7 */

/* Support iso_8859_8 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_8 */

/* Support iso_8859_9 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_8859_9 */

/* Support iso_ir_111 input encoding. */
/* #undef _ICONV_FROM_ENCODING_ISO_IR_111 */

/* Support koi8_r input encoding. */
/* #undef _ICONV_FROM_ENCODING_KOI8_R */

/* Support koi8_ru input encoding. */
/* #undef _ICONV_FROM_ENCODING_KOI8_RU */

/* Support koi8_u input encoding. */
/* #undef _ICONV_FROM_ENCODING_KOI8_U */

/* Support koi8_uni input encoding. */
/* #undef _ICONV_FROM_ENCODING_KOI8_UNI */

/* Support ucs_2 input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_2 */

/* Support ucs_2be input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_2BE */

/* Support ucs_2le input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_2LE */

/* Support ucs_2_internal input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_2_INTERNAL */

/* Support ucs_4 input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_4 */

/* Support ucs_4be input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_4BE */

/* Support ucs_4le input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_4LE */

/* Support ucs_4_internal input encoding. */
/* #undef _ICONV_FROM_ENCODING_UCS_4_INTERNAL */

/* Support us_ascii input encoding. */
/* #undef _ICONV_FROM_ENCODING_US_ASCII */

/* Support utf_16 input encoding. */
/* #undef _ICONV_FROM_ENCODING_UTF_16 */

/* Support utf_16be input encoding. */
/* #undef _ICONV_FROM_ENCODING_UTF_16BE */

/* Support utf_16le input encoding. */
/* #undef _ICONV_FROM_ENCODING_UTF_16LE */

/* Support utf_8 input encoding. */
/* #undef _ICONV_FROM_ENCODING_UTF_8 */

/* Support win_1250 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1250 */

/* Support win_1251 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1251 */

/* Support win_1252 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1252 */

/* Support win_1253 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1253 */

/* Support win_1254 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1254 */

/* Support win_1255 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1255 */

/* Support win_1256 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1256 */

/* Support win_1257 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1257 */

/* Support win_1258 input encoding. */
/* #undef _ICONV_FROM_ENCODING_WIN_1258 */

/* Support big5 output encoding. */
/* #undef _ICONV_TO_ENCODING_BIG5 */

/* Support cp775 output encoding. */
/* #undef _ICONV_TO_ENCODING_CP775 */

/* Support cp850 output encoding. */
/* #undef _ICONV_TO_ENCODING_CP850 */

/* Support cp852 output encoding. */
/* #undef _ICONV_TO_ENCODING_CP852 */

/* Support cp855 output encoding. */
/* #undef _ICONV_TO_ENCODING_CP855 */

/* Support cp866 output encoding. */
/* #undef _ICONV_TO_ENCODING_CP866 */

/* Support euc_jp output encoding. */
/* #undef _ICONV_TO_ENCODING_EUC_JP */

/* Support euc_kr output encoding. */
/* #undef _ICONV_TO_ENCODING_EUC_KR */

/* Support euc_tw output encoding. */
/* #undef _ICONV_TO_ENCODING_EUC_TW */

/* Support iso_8859_1 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_1 */

/* Support iso_8859_10 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_10 */

/* Support iso_8859_11 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_11 */

/* Support iso_8859_13 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_13 */

/* Support iso_8859_14 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_14 */

/* Support iso_8859_15 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_15 */

/* Support iso_8859_2 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_2 */

/* Support iso_8859_3 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_3 */

/* Support iso_8859_4 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_4 */

/* Support iso_8859_5 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_5 */

/* Support iso_8859_6 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_6 */

/* Support iso_8859_7 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_7 */

/* Support iso_8859_8 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_8 */

/* Support iso_8859_9 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_8859_9 */

/* Support iso_ir_111 output encoding. */
/* #undef _ICONV_TO_ENCODING_ISO_IR_111 */

/* Support koi8_r output encoding. */
/* #undef _ICONV_TO_ENCODING_KOI8_R */

/* Support koi8_ru output encoding. */
/* #undef _ICONV_TO_ENCODING_KOI8_RU */

/* Support koi8_u output encoding. */
/* #undef _ICONV_TO_ENCODING_KOI8_U */

/* Support koi8_uni output encoding. */
/* #undef _ICONV_TO_ENCODING_KOI8_UNI */

/* Support ucs_2 output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_2 */

/* Support ucs_2be output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_2BE */

/* Support ucs_2le output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_2LE */

/* Support ucs_2_internal output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_2_INTERNAL */

/* Support ucs_4 output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_4 */

/* Support ucs_4be output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_4BE */

/* Support ucs_4le output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_4LE */

/* Support ucs_4_internal output encoding. */
/* #undef _ICONV_TO_ENCODING_UCS_4_INTERNAL */

/* Support us_ascii output encoding. */
/* #undef _ICONV_TO_ENCODING_US_ASCII */

/* Support utf_16 output encoding. */
/* #undef _ICONV_TO_ENCODING_UTF_16 */

/* Support utf_16be output encoding. */
/* #undef _ICONV_TO_ENCODING_UTF_16BE */

/* Support utf_16le output encoding. */
/* #undef _ICONV_TO_ENCODING_UTF_16LE */

/* Support utf_8 output encoding. */
/* #undef _ICONV_TO_ENCODING_UTF_8 */

/* Support win_1250 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1250 */

/* Support win_1251 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1251 */

/* Support win_1252 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1252 */

/* Support win_1253 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1253 */

/* Support win_1254 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1254 */

/* Support win_1255 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1255 */

/* Support win_1256 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1256 */

/* Support win_1257 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1257 */

/* Support win_1258 output encoding. */
/* #undef _ICONV_TO_ENCODING_WIN_1258 */

/* Define if the platform long double type is equal to double. */
/* #undef _LDBL_EQ_DBL */

/* Define if lite version of exit supported. */
/* #undef _LITE_EXIT */

/* Multibyte supported. */
/* #undef _MB_CAPABLE */

/* Multibyte max length. */
#define _MB_LEN_MAX 1

/* Define if small footprint nano-formatted-IO implementation used. */
/* #undef _NANO_FORMATTED_IO */

/* nano version of malloc is used. */
/* #undef _NANO_MALLOC */

/* The newlib version in string format. */

/* Verify _REENT_CHECK macros allocate memory successfully. */
#define _REENT_CHECK_VERIFY 1

/* Define if using retargetable functions for default lock routines. */
/* #undef _RETARGETABLE_LOCKING */

/* Define if unbuffered stream file optimization is supported. */
#define _UNBUF_STREAM_OPT 1

/* Enable C99 formats support (e.g. %a, %zu, ...) in IO functions like
   printf/scanf. */
#define _WANT_IO_C99_FORMATS 1

/* Define to enable long double type support in IO functions like
   printf/scanf. */
#define _WANT_IO_LONG_DOUBLE 1

/* Define to enable long long type support in IO functions like printf/scanf.
   */
#define _WANT_IO_LONG_LONG 1

/* Positional argument support in printf functions enabled. */
/* #undef _WANT_IO_POS_ARGS */

/* Define to enable backward binary compatibility for struct _reent. */
/* #undef _WANT_REENT_BACKWARD_BINARY_COMPAT */

/* Optional reentrant struct support. Used mostly on platforms with very
   restricted storage. */
/* #undef _WANT_REENT_SMALL */

/* Define to enable thread-local storage objects as a replacment for struct
   _reent members. */
/* #undef _WANT_REENT_THREAD_LOCAL */

/* Register application finalization function using atexit. */
#define _WANT_REGISTER_FINI 1

/* Define if using gdtoa rather than legacy ldtoa. */
#define _WANT_USE_GDTOA 1

/* Define to use type long for time_t. */
/* #undef _WANT_USE_LONG_TIME_T */

/* Define if wide char orientation is supported. */
#define _WIDE_ORIENT 1

/* The newlib minor version number. */

/* The newlib patch level. */

/* The newlib major version number. */

#endif /* !__NEWLIB_H__ */
# 428 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/newlib.h" 3
#endif /* newlib.h expanded by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 2 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* config.h expanded by -frewrite-includes */
#include <sys/config.h>
#else /* config.h expanded by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 1 3
#ifndef __SYS_CONFIG_H__
#define __SYS_CONFIG_H__

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* ieeefp.h expanded by -frewrite-includes */
#include <machine/ieeefp.h>  /* floating point macros */
#else /* ieeefp.h expanded by -frewrite-includes */
# 4 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 1 3
#ifndef __IEEE_BIG_ENDIAN
#ifndef __IEEE_LITTLE_ENDIAN

/* This file can define macros to choose variations of the IEEE float
   format:

   _FLT_LARGEST_EXPONENT_IS_NORMAL

	Defined if the float format uses the largest exponent for finite
	numbers rather than NaN and infinity representations.  Such a
	format cannot represent NaNs or infinities at all, but it's FLT_MAX
	is twice the IEEE value.

   _FLT_NO_DENORMALS

	Defined if the float format does not support IEEE denormals.  Every
	float with a zero exponent is taken to be a zero representation.
 
   ??? At the moment, there are no equivalent macros above for doubles and
   the macros are not fully supported by --enable-newlib-hw-fp.

   __IEEE_BIG_ENDIAN

        Defined if the float format is big endian.  This is mutually exclusive
        with __IEEE_LITTLE_ENDIAN.

   __IEEE_LITTLE_ENDIAN
 
        Defined if the float format is little endian.  This is mutually exclusive
        with __IEEE_BIG_ENDIAN.

   Note that one of __IEEE_BIG_ENDIAN or __IEEE_LITTLE_ENDIAN must be specified for a
   platform or error will occur.

   __IEEE_BYTES_LITTLE_ENDIAN

        This flag is used in conjunction with __IEEE_BIG_ENDIAN to describe a situation 
	whereby multiple words of an IEEE floating point are in big endian order, but the
	words themselves are little endian with respect to the bytes.

   _DOUBLE_IS_32BITS 

        This is used on platforms that support double by using the 32-bit IEEE
        float type.

   _FLOAT_ARG

        This represents what type a float arg is passed as.  It is used when the type is
        not promoted to double.
	

   __OBSOLETE_MATH_DEFAULT

	Default value for __OBSOLETE_MATH if that's not set by the user.
	It should be set here based on predefined feature macros.

   __OBSOLETE_MATH

	If set to 1 then some new math code will be disabled and older libm
	code will be used instead.  This is necessary because the new math
	code does not support all targets, it assumes that the toolchain has
	ISO C99 support (hexfloat literals, standard fenv semantics), the
	target has IEEE-754 conforming binary32 float and binary64 double
	(not mixed endian) representation, standard SNaN representation,
	double and single precision arithmetics has similar latency and it
	has no legacy SVID matherr support, only POSIX errno and fenv
	exception based error handling.
*/

#if 0 /* disabled by -frewrite-includes */
#if (defined(__arm__) || defined(__thumb__)) && !defined(__MAVERICK__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
/* ARM traditionally used big-endian words; and within those words the
   byte ordering was big or little endian depending upon the target.
   Modern floating-point formats are naturally ordered; in this case
   __VFP_FP__ will be defined, even if soft-float.  */
#ifdef __VFP_FP__
# ifdef __ARMEL__
#  define __IEEE_LITTLE_ENDIAN
# else
# 79 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#  define __IEEE_BIG_ENDIAN
# endif
# 81 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#if 0 /* disabled by -frewrite-includes */
# if __ARM_FP & 0x8
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 82 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#  define __OBSOLETE_MATH_DEFAULT 0
# endif
# 84 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#else
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
# define __IEEE_BIG_ENDIAN
# ifdef __ARMEL__
#  define __IEEE_BYTES_LITTLE_ENDIAN
# endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 90 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#ifndef __SOFTFP__
# define _SUPPORTS_ERREXCEPT
#endif
# 93 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
/* As per ISO/IEC TS 18661 '__FLT_EVAL_METHOD__' will be defined to 16
   (if compiling with +fp16 support) so it can't be used by math.h to
   define float_t and double_t.  For values of '__FLT_EVAL_METHOD__'
   other than 0, 1, 2 the definition of float_t and double_t is
   implementation-defined.  */
#define __DOUBLE_TYPE double
#define __FLOAT_TYPE float
#endif
# 101 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined (__aarch64__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined (__AARCH64EL__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#else
# 106 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 108 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __OBSOLETE_MATH_DEFAULT 0
#ifdef __ARM_FP
# define _SUPPORTS_ERREXCEPT
#endif
# 112 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
/* As per ISO/IEC TS 18661 '__FLT_EVAL_METHOD__' will be defined to 16
   (if compiling with +fp16 support) so it can't be used by math.h to
   define float_t and double_t.  For values of '__FLT_EVAL_METHOD__'
   other than 0, 1, 2 the definition of float_t and double_t is
   implementation-defined.  */
#define __DOUBLE_TYPE double
#define __FLOAT_TYPE float
#endif
# 120 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __epiphany__
#define __IEEE_LITTLE_ENDIAN
#define Sudden_Underflow 1
#endif
# 125 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __hppa__
#define __IEEE_BIG_ENDIAN
#endif
# 129 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __nds32__
#ifdef __big_endian__
#define __IEEE_BIG_ENDIAN
#else
# 134 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 136 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 137 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __SPU__
#define __IEEE_BIG_ENDIAN

#define isfinite(__y) \
	(__extension__ ({int __cy; \
		(sizeof (__y) == sizeof (float))  ? (1) : \
		(__cy = fpclassify(__y)) != FP_INFINITE && __cy != FP_NAN;}))

#define isinf(__x) ((sizeof (__x) == sizeof (float))  ?  (0) : __isinfd(__x))
#define isnan(__x) ((sizeof (__x) == sizeof (float))  ?  (0) : __isnand(__x))

/*
 * Macros for use in ieeefp.h. We can't just define the real ones here
 * (like those above) as we have name space issues when this is *not*
 * included via generic the ieeefp.h.
 */
#define __ieeefp_isnanf(x)	0
#define __ieeefp_isinff(x)	0
#define __ieeefp_finitef(x)	1
#endif
# 158 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __sparc__
#ifdef __LITTLE_ENDIAN_DATA__
#define __IEEE_LITTLE_ENDIAN
#else
# 163 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 165 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 166 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__m68k__) || defined(__mc68000__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 168 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 170 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__mc68hc11__) || defined(__mc68hc12__) || defined(__mc68hc1x__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 172 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#ifdef __HAVE_SHORT_DOUBLE__
# define _DOUBLE_IS_32BITS
#endif
# 176 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 177 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined (__H8300__) || defined (__H8300H__) || defined (__H8300S__) || defined (__H8500__) || defined (__H8300SX__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 179 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#define _FLOAT_ARG float
#define _DOUBLE_IS_32BITS
#endif
# 183 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined (__xc16x__) || defined (__xc16xL__) || defined (__xc16xS__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 185 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#define _FLOAT_ARG float
#define _DOUBLE_IS_32BITS
#endif
# 189 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3


#ifdef __sh__
#ifdef __LITTLE_ENDIAN__
#define __IEEE_LITTLE_ENDIAN
#else
# 195 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 197 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__SH2E__) || defined(__SH3E__) || defined(__SH4_SINGLE_ONLY__) || defined(__SH2A_SINGLE_ONLY__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 198 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define _DOUBLE_IS_32BITS
#endif
# 200 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 201 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef _AM29K
#define __IEEE_BIG_ENDIAN
#endif
# 205 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef _WIN32
#define __IEEE_LITTLE_ENDIAN
#endif
# 209 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __i386__
#define __IEEE_LITTLE_ENDIAN
# define _SUPPORTS_ERREXCEPT
#endif
# 214 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __riscv
#if 0 /* disabled by -frewrite-includes */
#if defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 217 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#else
# 219 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 221 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__riscv_flen) || defined (__riscv_zfinx)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 222 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
# define _SUPPORTS_ERREXCEPT
#endif
# 224 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (__riscv_flen == 64) || defined (__riscv_zdinx)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 225 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
# define __OBSOLETE_MATH_DEFAULT 0
#else
# 227 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
# define __OBSOLETE_MATH_DEFAULT 1
#endif
# 229 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 230 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __i960__
#define __IEEE_LITTLE_ENDIAN
#endif
# 234 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __lm32__
#define __IEEE_BIG_ENDIAN
#endif
# 238 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __M32R__
#define __IEEE_BIG_ENDIAN
#endif
# 242 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __nvptx__
#define __IEEE_LITTLE_ENDIAN
#endif
# 246 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_C4x) || defined(_C3x)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 248 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#define _DOUBLE_IS_32BITS
#endif
# 251 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __TMS320C6X__
#ifdef _BIG_ENDIAN
#define __IEEE_BIG_ENDIAN
#else
# 256 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 258 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 259 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __TIC80__
#define __IEEE_LITTLE_ENDIAN
#endif
# 263 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __MIPSEL__
#define __IEEE_LITTLE_ENDIAN
#endif
# 267 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#ifdef __MIPSEB__
#define __IEEE_BIG_ENDIAN
#endif
# 270 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __MMIX__
#define __IEEE_BIG_ENDIAN
#endif
# 274 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __D30V__
#define __IEEE_BIG_ENDIAN
#endif
# 278 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

/* necv70 was __IEEE_LITTLE_ENDIAN. */

#ifdef __W65__
#define __IEEE_LITTLE_ENDIAN
#define _DOUBLE_IS_32BITS
#endif
# 285 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__Z8001__) || defined(__Z8002__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 287 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 289 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __m88k__
#define __IEEE_BIG_ENDIAN
#endif
# 293 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __mn10300__
#define __IEEE_LITTLE_ENDIAN
#endif
# 297 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __mn10200__
#define __IEEE_LITTLE_ENDIAN
#define _DOUBLE_IS_32BITS
#endif
# 302 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __v800
#define __IEEE_LITTLE_ENDIAN
#endif
# 306 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __v850
#define __IEEE_LITTLE_ENDIAN
#endif
# 310 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __D10V__
#define __IEEE_BIG_ENDIAN
#if 0 /* disabled by -frewrite-includes */
#if __DOUBLE__ == 32
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 314 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define _DOUBLE_IS_32BITS
#endif
# 316 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 317 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __PPC__
#if 0 /* disabled by -frewrite-includes */
#if (defined(_BIG_ENDIAN) && _BIG_ENDIAN) || (defined(_AIX) && _AIX)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 320 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#else
# 322 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(_LITTLE_ENDIAN) && _LITTLE_ENDIAN) || (defined(__sun__) && __sun__) || (defined(_WIN32) && _WIN32)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 323 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 325 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 326 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 327 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __xstormy16__
#define __IEEE_LITTLE_ENDIAN
#endif
# 331 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __arc__
#ifdef __big_endian__
#define __IEEE_BIG_ENDIAN
#else
# 336 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 338 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 339 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __CRX__
#define __IEEE_LITTLE_ENDIAN
#endif
# 343 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __CSKY__
#ifdef __CSKYBE__
#define __IEEE_BIG_ENDIAN
#else
# 348 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 350 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 351 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __fr30__
#define __IEEE_BIG_ENDIAN
#endif
# 355 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __FT32__
#define __IEEE_LITTLE_ENDIAN
#endif
# 359 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __mcore__
#define __IEEE_BIG_ENDIAN
#endif
# 363 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __mt__
#define __IEEE_BIG_ENDIAN
#endif
# 367 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __frv__
#define __IEEE_BIG_ENDIAN
#endif
# 371 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __moxie__
#ifdef __MOXIE_BIG_ENDIAN__
#define __IEEE_BIG_ENDIAN
#else
# 376 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 378 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 379 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __ia64__
#ifdef __BIG_ENDIAN__
#define __IEEE_BIG_ENDIAN
#else
# 384 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 386 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 387 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __AVR__
#define __IEEE_LITTLE_ENDIAN
#define _DOUBLE_IS_32BITS
#endif
# 392 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__or1k__) || defined(__OR1K__) || defined(__OR1KND__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 394 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 396 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __IP2K__
#define __IEEE_BIG_ENDIAN
#define __SMALL_BITFIELDS
#define _DOUBLE_IS_32BITS
#endif
# 402 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __iq2000__
#define __IEEE_BIG_ENDIAN
#endif
# 406 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __MAVERICK__
#ifdef __ARMEL__
#  define __IEEE_LITTLE_ENDIAN
#else  /* must be __ARMEB__ */
# 411 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#  define __IEEE_BIG_ENDIAN
#endif /* __ARMEL__ */
# 413 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif /* __MAVERICK__ */
# 414 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __m32c__
#define __IEEE_LITTLE_ENDIAN
#define __SMALL_BITFIELDS
#endif
# 419 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __CRIS__
#define __IEEE_LITTLE_ENDIAN
#endif
# 423 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __BFIN__
#define __IEEE_LITTLE_ENDIAN
#endif
# 427 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __x86_64__
#define __IEEE_LITTLE_ENDIAN
# define _SUPPORTS_ERREXCEPT
#endif
# 432 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __mep__
#ifdef __LITTLE_ENDIAN__
#define __IEEE_LITTLE_ENDIAN
#else
# 437 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_BIG_ENDIAN
#endif
# 439 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 440 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __MICROBLAZE__
#ifndef __MICROBLAZEEL__
#define __IEEE_BIG_ENDIAN
#else
# 445 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 447 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 448 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __MSP430__
#define __IEEE_LITTLE_ENDIAN
#define __SMALL_BITFIELDS	/* 16 Bit INT */
#endif
# 453 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __PRU__
#define __IEEE_LITTLE_ENDIAN
#endif
# 457 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __RL78__
#define __IEEE_LITTLE_ENDIAN
#define __SMALL_BITFIELDS	/* 16 Bit INT */
#ifndef __RL78_64BIT_DOUBLES__
#define _DOUBLE_IS_32BITS
#endif
# 464 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 465 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __RX__

#ifdef __RX_BIG_ENDIAN__
#define __IEEE_BIG_ENDIAN
#else
# 471 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#endif
# 473 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifndef __RX_64BIT_DOUBLES__
#define _DOUBLE_IS_32BITS
#endif
# 477 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __RX_16BIT_INTS__
#define __SMALL_BITFIELDS
#endif
# 481 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#endif
# 483 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#if 0 /* disabled by -frewrite-includes */
#if (defined(__CR16__) || defined(__CR16C__) ||defined(__CR16CP__))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 485 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#define __IEEE_LITTLE_ENDIAN
#define __SMALL_BITFIELDS	/* 16 Bit INT */
#endif
# 488 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __NIOS2__
# ifdef __nios2_big_endian__
#  define __IEEE_BIG_ENDIAN
# else
# 493 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#  define __IEEE_LITTLE_ENDIAN
# endif
# 495 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif
# 496 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __VISIUM__
#define __IEEE_BIG_ENDIAN
#endif
# 500 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __AMDGCN__
#define __IEEE_LITTLE_ENDIAN
#endif
# 504 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __XTENSA_EL__
#define __IEEE_LITTLE_ENDIAN
#endif
# 508 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __XTENSA_EB__
#define __IEEE_BIG_ENDIAN
#endif
# 512 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifdef __CYGWIN__
#define __OBSOLETE_MATH_DEFAULT 0
#endif
# 516 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifndef __OBSOLETE_MATH_DEFAULT
/* Use old math code by default.  */
#define __OBSOLETE_MATH_DEFAULT 1
#endif
# 521 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#ifndef __OBSOLETE_MATH
#define __OBSOLETE_MATH __OBSOLETE_MATH_DEFAULT
#endif
# 524 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#ifndef __IEEE_BIG_ENDIAN
#ifndef __IEEE_LITTLE_ENDIAN
#error Endianess not declared!!
#endif /* not __IEEE_LITTLE_ENDIAN */
# 529 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif /* not __IEEE_BIG_ENDIAN */
# 530 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#endif /* not __IEEE_LITTLE_ENDIAN */
# 532 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3
#endif /* not __IEEE_BIG_ENDIAN */
# 533 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/ieeefp.h" 3

#endif /* ieeefp.h expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 2 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/features.h>	/* POSIX defs */
#endif /* expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __aarch64__
#define MALLOC_ALIGNMENT 16
#endif
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __AMDGCN__
#define __DYNAMIC_REENT__
#endif
# 14 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* exceptions first */
#if 0 /* disabled by -frewrite-includes */
#if defined(__H8500__) || defined(__W65__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __SMALL_BITFIELDS
/* ???  This conditional is true for the h8500 and the w65, defining H8300
   in those cases probably isn't the right thing to do.  */
#define H8300 1
#endif
# 22 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* 16 bit integer machines */
#if 0 /* disabled by -frewrite-includes */
#if defined(__Z8001__) || defined(__Z8002__) || defined(__H8500__) || defined(__W65__) || defined (__mn10200__) || defined (__AVR__) || defined (__MSP430__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#undef INT_MAX
#undef UINT_MAX
#define INT_MAX 32767
#define UINT_MAX 65535
#endif
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined (__H8300__) || defined (__H8300H__) || defined(__H8300S__) || defined (__H8300SX__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __SMALL_BITFIELDS
#define H8300 1
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX __INT_MAX__
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#endif
# 40 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if (defined(__CR16__) || defined(__CR16C__) ||defined(__CR16CP__))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 42 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#ifndef __INT32__
#define __SMALL_BITFIELDS      
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX 32767
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#else /* INT32 */
# 49 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX 2147483647
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#endif /* INT32 */
# 54 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#endif /* CR16C */
# 56 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined (__xc16x__) || defined (__xc16xL__) || defined (__xc16xS__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 58 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __SMALL_BITFIELDS
#endif
# 60 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __W65__
#define __SMALL_BITFIELDS
#endif
# 64 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__D10V__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 66 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __SMALL_BITFIELDS
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX __INT_MAX__
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#define _POINTER_INT short
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__mc68hc11__) || defined(__mc68hc12__) || defined(__mc68hc1x__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 75 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX __INT_MAX__
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#define _POINTER_INT short
#endif
# 81 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__m68k__) || defined(__mc68000__) || defined(__riscv)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 83 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define _READ_WRITE_RETURN_TYPE _ssize_t
#endif
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef ___AM29K__
#define _FLOAT_RET double
#endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __i386__
#ifndef __unix__
/* in other words, go32 */
#define _FLOAT_RET double
#endif
# 95 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__linux__) || defined(__RDOS__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 96 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
/* we want the reentrancy structure to be returned by a function */
#define __DYNAMIC_REENT__
#define HAVE_GETDATE
#define _READ_WRITE_RETURN_TYPE _ssize_t
#define __LARGE64_FILES 1
/* we use some glibc header files so turn on glibc large file feature */
#define _LARGEFILE64_SOURCE 1
#endif
# 104 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 105 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __mn10200__
#define __SMALL_BITFIELDS
#endif
# 109 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __AVR__
#define __SMALL_BITFIELDS
#define _POINTER_INT short
#endif
# 114 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__v850) && !defined(__rtems__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 116 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __ATTRIBUTE_IMPURE_PTR__ __attribute__((__sda__))
#endif
# 118 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* For the PowerPC eabi, force the _impure_ptr to be in .sdata */
#if 0 /* disabled by -frewrite-includes */
#if defined(__PPC__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 121 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(_CALL_SYSV)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 122 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __ATTRIBUTE_IMPURE_PTR__ __attribute__((__section__(".sdata")))
#endif
# 124 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#ifdef __SPE__
#define _LONG_DOUBLE double
#endif
# 127 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 128 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* Configure small REENT structure for Xilinx MicroBlaze platforms */
#if 0 /* disabled by -frewrite-includes */
#if defined (__MICROBLAZE__) && !defined(__rtems__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 131 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#ifndef _REENT_SMALL
#define _REENT_SMALL
#endif
# 134 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
/* Xilinx XMK uses Unix98 mutex */
#ifdef __XMK__
#define _UNIX98_THREAD_MUTEX_ATTRIBUTES
#endif
# 138 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 139 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__mips__) && !defined(__rtems__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 141 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __ATTRIBUTE_IMPURE_PTR__ __attribute__((__section__(".sdata")))
#endif
# 143 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __xstormy16__
#define __SMALL_BITFIELDS
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX __INT_MAX__
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#define MALLOC_ALIGNMENT 8
#define _POINTER_INT short
#define __BUFSIZ__ 16
#define _REENT_SMALL
#endif
# 155 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined __MSP430__
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 157 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#ifndef _REENT_SMALL
#define _REENT_SMALL
#endif
# 160 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#define __BUFSIZ__ 256
#define __SMALL_BITFIELDS

#ifdef __MSP430X_LARGE__
#define _POINTER_INT __int20
#else
# 167 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define _POINTER_INT int
#endif
# 169 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 170 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __m32c__
#define __SMALL_BITFIELDS
#undef INT_MAX
#undef UINT_MAX
#define INT_MAX __INT_MAX__
#define UINT_MAX (__INT_MAX__ * 2U + 1)
#define MALLOC_ALIGNMENT 8
#if 0 /* disabled by -frewrite-includes */
#if defined(__r8c_cpu__) || defined(__m16c_cpu__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 179 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define _POINTER_INT short
#else
# 181 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define _POINTER_INT long
#endif
# 183 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __BUFSIZ__ 16
#define _REENT_SMALL
#endif /* __m32c__ */
# 186 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __SPU__
#define MALLOC_ALIGNMENT 16
#define __CUSTOM_FILE_IO__
#endif
# 191 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__or1k__) || defined(__or1knd__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 193 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __DYNAMIC_REENT__
#endif
# 195 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* This block should be kept in sync with GCC's limits.h.  The point
   of having these definitions here is to not include limits.h, which
   would pollute the user namespace, while still using types of the
   the correct widths when deciding how to define __int32_t and
   __int64_t.  */
#ifndef __INT_MAX__
# ifdef INT_MAX
#  define __INT_MAX__ INT_MAX
# else
# 205 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#  define __INT_MAX__ 2147483647
# endif
# 207 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 208 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifndef __LONG_MAX__
# ifdef LONG_MAX
#  define __LONG_MAX__ LONG_MAX
# else
# 213 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#if 0 /* disabled by -frewrite-includes */
#  if defined (__alpha__) || (defined (__sparc__) && defined(__arch64__)) \
      || defined (__sparcv9)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 215 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#   define __LONG_MAX__ 9223372036854775807L
#  else
# 217 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#   define __LONG_MAX__ 2147483647L
#  endif /* __alpha__ || sparc64 */
# 219 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
# endif
# 220 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 221 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
/* End of block that should be kept in sync with GCC's limits.h.  */

#ifndef _POINTER_INT
#define _POINTER_INT long
#endif
# 226 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef __frv__
#define __ATTRIBUTE_IMPURE_PTR__ __attribute__((__section__(".sdata")))
#endif
# 230 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#undef __RAND_MAX
#if 0 /* disabled by -frewrite-includes */
#if __INT_MAX__ == 32767
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 232 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __RAND_MAX 32767
#else
# 234 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __RAND_MAX 0x7fffffff
#endif
# 236 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__CYGWIN__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 238 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <cygwin/config.h>
#endif /* expanded by -frewrite-includes */
# 238 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
# 239 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 240 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__rtems__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 242 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __FILENAME_MAX__ 255
#define _READ_WRITE_RETURN_TYPE _ssize_t
#define __DYNAMIC_REENT__
#endif
# 246 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifndef __EXPORT
#define __EXPORT
#endif
# 250 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifndef __IMPORT
#define __IMPORT
#endif
# 254 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* Define return type of read/write routines.  In POSIX, the return type
   for read()/write() is "ssize_t" but legacy newlib code has been using
   "int" for some time.  If not specified, "int" is defaulted.  */
#ifndef _READ_WRITE_RETURN_TYPE
#define _READ_WRITE_RETURN_TYPE int
#endif
# 261 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
/* Define `count' parameter of read/write routines.  In POSIX, the `count'
   parameter is "size_t" but legacy newlib code has been using "int" for some
   time.  If not specified, "int" is defaulted.  */
#ifndef _READ_WRITE_BUFSIZE_TYPE
#define _READ_WRITE_BUFSIZE_TYPE int
#endif
# 267 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifndef __WCHAR_MAX__
#if 0 /* disabled by -frewrite-includes */
#if __INT_MAX__ == 32767 || defined (_WIN32)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 270 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#define __WCHAR_MAX__ 0xffffu
#endif
# 272 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 273 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* See if small reent asked for at configuration time and
   is not chosen by the platform by default.  */
#ifdef _WANT_REENT_SMALL
#ifndef _REENT_SMALL
#define _REENT_SMALL
#endif
# 280 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 281 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef _WANT_USE_LONG_TIME_T
#ifndef _USE_LONG_TIME_T
#define _USE_LONG_TIME_T
#endif
# 286 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 287 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef _WANT_USE_GDTOA
#ifndef _USE_GDTOA
#define _USE_GDTOA
#endif
# 292 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 293 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef _WANT_REENT_BACKWARD_BINARY_COMPAT
#ifndef _REENT_BACKWARD_BINARY_COMPAT
#define _REENT_BACKWARD_BINARY_COMPAT
#endif
# 298 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 299 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#ifdef _WANT_REENT_THREAD_LOCAL
#ifndef _REENT_THREAD_LOCAL
#define _REENT_THREAD_LOCAL
#endif
# 304 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif
# 305 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

/* If _MB_EXTENDED_CHARSETS_ALL is set, we want all of the extended
   charsets.  The extended charsets add a few functions and a couple
   of tables of a few K each. */
#ifdef _MB_EXTENDED_CHARSETS_ALL
#define _MB_EXTENDED_CHARSETS_ISO 1
#define _MB_EXTENDED_CHARSETS_WINDOWS 1
#endif
# 313 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3

#endif /* __SYS_CONFIG_H__ */
# 315 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/config.h" 3
#endif /* config.h expanded by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 2 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/_intsup.h>
#endif /* expanded by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _ansi.h expanded by -frewrite-includes */
#include "_ansi.h"
#else /* _ansi.h expanded by -frewrite-includes */
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 1 3
/* Provide support for both ANSI and non-ANSI environments.  */

/* To get a strict ANSI C environment, define macro __STRICT_ANSI__.  This will
   "comment out" the non-ANSI parts of the ANSI header files (non-ANSI header
   files aren't affected).  */

#ifndef	_ANSIDECL_H_
#define	_ANSIDECL_H_

#if 0 /* expanded by -frewrite-includes */
#include <newlib.h>
#endif /* expanded by -frewrite-includes */
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
# 11 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/config.h>
#endif /* expanded by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3

/*  ISO C++.  */

#ifdef __cplusplus
#if 0 /* disabled by -frewrite-includes */
#if !(defined(_BEGIN_STD_C) && defined(_END_STD_C))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#ifdef _HAVE_STD_CXX
#define _BEGIN_STD_C namespace std { extern "C" {
#define _END_STD_C  } }
#else
# 21 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#define _BEGIN_STD_C extern "C" {
#define _END_STD_C  }
#endif
# 24 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ (3, 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#define _NOTHROW __attribute__ ((__nothrow__))
#else
# 27 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#define _NOTHROW throw()
#endif
# 29 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#endif
# 30 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#else
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#define _BEGIN_STD_C
#define _END_STD_C
#define _NOTHROW
#endif
# 35 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3

#ifndef _LONG_DOUBLE
#define _LONG_DOUBLE long double
#endif
# 39 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3

/* Support gcc's __attribute__ facility.  */

#ifdef __GNUC__
#define _ATTRIBUTE(attrs) __attribute__ (attrs)
#else
# 45 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#define _ATTRIBUTE(attrs)
#endif
# 47 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3

/*  The traditional meaning of 'extern inline' for GCC is not
  to emit the function body unless the address is explicitly
  taken.  However this behaviour is changing to match the C99
  standard, which uses 'extern inline' to indicate that the
  function body *must* be emitted.  Likewise, a function declared
  without either 'extern' or 'static' defaults to extern linkage
  (C99 6.2.2p5), and the compiler may choose whether to use the
  inline version or call the extern linkage version (6.7.4p6).
  If we are using GCC, but do not have the new behaviour, we need
  to use extern inline; if we are using a new GCC with the
  C99-compatible behaviour, or a non-GCC compiler (which we will
  have to hope is C99, since there is no other way to achieve the
  effect of omitting the function if it isn't referenced) we use
  'static inline', which c99 defines to mean more-or-less the same
  as the Gnu C 'extern inline'.  */
#if 0 /* disabled by -frewrite-includes */
#if defined(__GNUC__) && !defined(__GNUC_STDC_INLINE__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 64 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
/* We're using GCC, but without the new C99-compatible behaviour.  */
#define _ELIDABLE_INLINE extern __inline__ _ATTRIBUTE ((__always_inline__))
#else
# 67 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
/* We're using GCC in C99 mode, or an unknown compiler which
  we just have to hope obeys the C99 semantics of inline.  */
#define _ELIDABLE_INLINE static __inline__
#endif
# 71 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ (3, 1)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 73 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#define _NOINLINE		__attribute__ ((__noinline__))
#define _NOINLINE_STATIC	_NOINLINE static
#else
# 76 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
/* On non-GNU compilers and GCC prior to version 3.1 the compiler can't be
   trusted not to inline if it is static. */
#define _NOINLINE
#define _NOINLINE_STATIC
#endif
# 81 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3

#endif /* _ANSIDECL_H_ */
# 83 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/_ansi.h" 3
#endif /* _ansi.h expanded by -frewrite-includes */
# 20 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 2 3
#if 0 /* expanded by -frewrite-includes */
#include <stdint.h>
#endif /* expanded by -frewrite-includes */
# 20 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 21 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define __need_wchar_t
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stddef.h expanded by -frewrite-includes */
#include <stddef.h>
#else /* stddef.h expanded by -frewrite-includes */
# 22 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 1 3
/*===---- stddef.h - Basic type definitions --------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stddef.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stddef.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#undef __need_size_t
#undef __need_rsize_t
#undef __need_wchar_t
#undef __need_NULL
#undef __need_nullptr_t
#undef __need_unreachable
#undef __need_max_align_t
#undef __need_offsetof
#undef __need_wint_t
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stddef.h>
#endif /* expanded by -frewrite-includes */
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#else
# 37 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__need_ptrdiff_t) && !defined(__need_size_t) &&                   \
    !defined(__need_rsize_t) && !defined(__need_wchar_t) &&                    \
    !defined(__need_NULL) && !defined(__need_nullptr_t) &&                     \
    !defined(__need_unreachable) && !defined(__need_max_align_t) &&            \
    !defined(__need_offsetof) && !defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 43 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_ptrdiff_t
#define __need_size_t
/* ISO9899:2011 7.20 (C11 Annex K): Define rsize_t if __STDC_WANT_LIB_EXT1__ is
 * enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_rsize_t
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_wchar_t
#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDDEF_H) || __has_feature(modules)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
/*
 * __stddef_null.h is special when building without modules: if __need_NULL is
 * set, then it will unconditionally redefine NULL. To avoid stepping on client
 * definitions of NULL, __need_NULL should only be set the first time this
 * header is included, that is when __STDDEF_H is not defined. However, when
 * building with modules, this header is a textual header and needs to
 * unconditionally include __stdef_null.h to support multiple submodules
 * exporting _Builtin_stddef.null. Take module SM with submodules A and B, whose
 * headers both include stddef.h When SM.A builds, __STDDEF_H will be defined.
 * When SM.B builds, the definition from SM.A will leak when building without
 * local submodule visibility. stddef.h wouldn't include __stddef_null.h, and
 * SM.B wouldn't import _Builtin_stddef.null, and SM.B's `export *` wouldn't
 * export NULL as expected. When building with modules, always include
 * __stddef_null.h so that everything works as expected.
 */
#define __need_NULL
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) ||              \
    defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_nullptr_t
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_unreachable
#endif
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 78 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_max_align_t
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_offsetof
/* wint_t is provided by <wchar.h> and not <stddef.h>. It's here
 * for compatibility, but must be explicitly requested. Therefore
 * __need_wint_t is intentionally not defined here. */
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 85 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_ptrdiff_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_ptrdiff_t.h>
#endif /* expanded by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 89 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#endif /* defined(__need_ptrdiff_t) */
# 91 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_size_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_size_t.h>
#endif /* expanded by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 94 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_size_t
#endif /*defined(__need_size_t) */
# 96 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_rsize_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_rsize_t.h>
#endif /* expanded by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_rsize_t
#endif /* defined(__need_rsize_t) */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wchar_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_wchar_t.h expanded by -frewrite-includes */
#include <__stddef_wchar_t.h>
#else /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 1 3
/*===---- __stddef_wchar.h - Definition of wchar_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(__cplusplus) || (defined(_MSC_VER) && !_NATIVE_WCHAR_T_DEFINED)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_WCHAR_T) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#define _WCHAR_T

#ifdef _MSC_EXTENSIONS
#define _WCHAR_T_DEFINED
#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

typedef __WCHAR_TYPE__ wchar_t;

#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

#endif
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#endif /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_wchar_t
#endif /* defined(__need_wchar_t) */
# 106 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_NULL)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_null.h>
#endif /* expanded by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 109 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_NULL
#endif /* defined(__need_NULL) */
# 111 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_nullptr_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_nullptr_t.h>
#endif /* expanded by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 114 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_nullptr_t
#endif /* defined(__need_nullptr_t) */
# 116 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_unreachable.h>
#endif /* expanded by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 119 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_unreachable
#endif /* defined(__need_unreachable) */
# 121 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_max_align_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_max_align_t.h>
#endif /* expanded by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 124 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_max_align_t
#endif /* defined(__need_max_align_t) */
# 126 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_offsetof)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_offsetof.h>
#endif /* expanded by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 129 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_offsetof
#endif /* defined(__need_offsetof) */
# 131 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

/* Some C libraries expect to see a wint_t here. Others (notably MinGW) will use
__WINT_TYPE__ directly; accommodate both by requiring __need_wint_t */
#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wint_t.h>
#endif /* expanded by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 136 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wint_t
#endif /* __need_wint_t */
# 138 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#endif /* __MVS__ */
# 140 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif /* stddef.h expanded by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 2 3

#if 0 /* disabled by -frewrite-includes */
#if __BSD_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _locale.h expanded by -frewrite-includes */
#include <sys/_locale.h>
#else /* _locale.h expanded by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_locale.h" 1 3
/* Definition of opaque POSIX-1.2008 type locale_t for userspace. */

#ifndef	_SYS__LOCALE_H
#define _SYS__LOCALE_H

#if 0 /* expanded by -frewrite-includes */
#include <newlib.h>
#endif /* expanded by -frewrite-includes */
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_locale.h" 3
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_locale.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/config.h>
#endif /* expanded by -frewrite-includes */
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_locale.h" 3
# 8 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_locale.h" 3

struct __locale_t;
typedef struct __locale_t *locale_t;

#endif	/* _SYS__LOCALE_H */
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_locale.h" 3
#endif /* _locale.h expanded by -frewrite-includes */
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 2 3
#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#define __STRINGIFY(a) #a

/* 8-bit types */
#define __PRI8(x) __INT8 __STRINGIFY(x)
#define __PRI8LEAST(x) __LEAST8 __STRINGIFY(x)
#define __PRI8FAST(x) __FAST8 __STRINGIFY(x)

/* NOTICE: scanning 8-bit types requires use of the hh specifier
 * which is only supported on newlib platforms that
 * are built with C99 I/O format support enabled.  If the flag in
 * newlib.h hasn't been set during configuration to indicate this, the 8-bit
 * scanning format macros are disabled here as they result in undefined
 * behaviour which can include memory overwrite.  Overriding the flag after the
 * library has been built is not recommended as it will expose the underlying
 * undefined behaviour.
 */

#if 0 /* disabled by -frewrite-includes */
#if defined(_WANT_IO_C99_FORMATS)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 46 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
  #define __SCN8(x) __INT8 __STRINGIFY(x)
	#define __SCN8LEAST(x) __LEAST8 __STRINGIFY(x)
	#define __SCN8FAST(x) __FAST8 __STRINGIFY(x)
#endif /* _WANT_IO_C99_FORMATS */
# 50 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3


#define PRId8		__PRI8(d)
#define PRIi8		__PRI8(i)
#define PRIo8		__PRI8(o)
#define PRIu8		__PRI8(u)
#define PRIx8		__PRI8(x)
#define PRIX8		__PRI8(X)

/* Macros below are only enabled for a newlib built with C99 I/O format support. */
#if 0 /* disabled by -frewrite-includes */
#if defined(_WANT_IO_C99_FORMATS)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 61 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#define SCNd8		__SCN8(d)
#define SCNi8		__SCN8(i)
#define SCNo8		__SCN8(o)
#define SCNu8		__SCN8(u)
#define SCNx8		__SCN8(x)

#endif /* _WANT_IO_C99_FORMATS */
# 69 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3


#define PRIdLEAST8	__PRI8LEAST(d)
#define PRIiLEAST8	__PRI8LEAST(i)
#define PRIoLEAST8	__PRI8LEAST(o)
#define PRIuLEAST8	__PRI8LEAST(u)
#define PRIxLEAST8	__PRI8LEAST(x)
#define PRIXLEAST8	__PRI8LEAST(X)

/* Macros below are only enabled for a newlib built with C99 I/O format support. */
#if 0 /* disabled by -frewrite-includes */
#if defined(_WANT_IO_C99_FORMATS)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 80 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

  #define SCNdLEAST8	__SCN8LEAST(d)
  #define SCNiLEAST8	__SCN8LEAST(i)
  #define SCNoLEAST8	__SCN8LEAST(o)
  #define SCNuLEAST8	__SCN8LEAST(u)
  #define SCNxLEAST8	__SCN8LEAST(x)

#endif /* _WANT_IO_C99_FORMATS */
# 88 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#define PRIdFAST8	__PRI8FAST(d)
#define PRIiFAST8	__PRI8FAST(i)
#define PRIoFAST8	__PRI8FAST(o)
#define PRIuFAST8	__PRI8FAST(u)
#define PRIxFAST8	__PRI8FAST(x)
#define PRIXFAST8	__PRI8FAST(X)

/* Macros below are only enabled for a newlib built with C99 I/O format support. */
#if 0 /* disabled by -frewrite-includes */
#if defined(_WANT_IO_C99_FORMATS)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

  #define SCNdFAST8	__SCN8FAST(d)
  #define SCNiFAST8	__SCN8FAST(i)
  #define SCNoFAST8	__SCN8FAST(o)
  #define SCNuFAST8	__SCN8FAST(u)
  #define SCNxFAST8	__SCN8FAST(x)

#endif /* _WANT_IO_C99_FORMATS */
# 106 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

/* 16-bit types */
#define __PRI16(x) __INT16 __STRINGIFY(x)
#define __PRI16LEAST(x) __LEAST16 __STRINGIFY(x)
#define __PRI16FAST(x) __FAST16 __STRINGIFY(x)
#define __SCN16(x) __INT16 __STRINGIFY(x)
#define __SCN16LEAST(x) __LEAST16 __STRINGIFY(x)
#define __SCN16FAST(x) __FAST16 __STRINGIFY(x)


#define PRId16		__PRI16(d)
#define PRIi16		__PRI16(i)
#define PRIo16		__PRI16(o)
#define PRIu16		__PRI16(u)
#define PRIx16		__PRI16(x)
#define PRIX16		__PRI16(X)

#define SCNd16		__SCN16(d)
#define SCNi16		__SCN16(i)
#define SCNo16		__SCN16(o)
#define SCNu16		__SCN16(u)
#define SCNx16		__SCN16(x)


#define PRIdLEAST16	__PRI16LEAST(d)
#define PRIiLEAST16	__PRI16LEAST(i)
#define PRIoLEAST16	__PRI16LEAST(o)
#define PRIuLEAST16	__PRI16LEAST(u)
#define PRIxLEAST16	__PRI16LEAST(x)
#define PRIXLEAST16	__PRI16LEAST(X)

#define SCNdLEAST16	__SCN16LEAST(d)
#define SCNiLEAST16	__SCN16LEAST(i)
#define SCNoLEAST16	__SCN16LEAST(o)
#define SCNuLEAST16	__SCN16LEAST(u)
#define SCNxLEAST16	__SCN16LEAST(x)


#define PRIdFAST16	__PRI16FAST(d)
#define PRIiFAST16	__PRI16FAST(i)
#define PRIoFAST16	__PRI16FAST(o)
#define PRIuFAST16	__PRI16FAST(u)
#define PRIxFAST16	__PRI16FAST(x)
#define PRIXFAST16	__PRI16FAST(X)

#define SCNdFAST16	__SCN16FAST(d)
#define SCNiFAST16	__SCN16FAST(i)
#define SCNoFAST16	__SCN16FAST(o)
#define SCNuFAST16	__SCN16FAST(u)
#define SCNxFAST16	__SCN16FAST(x)

/* 32-bit types */
#define __PRI32(x) __INT32 __STRINGIFY(x)
#define __SCN32(x) __INT32 __STRINGIFY(x)
#define __PRI32LEAST(x) __LEAST32 __STRINGIFY(x)
#define __SCN32LEAST(x) __LEAST32 __STRINGIFY(x)
#define __PRI32FAST(x) __FAST32 __STRINGIFY(x)
#define __SCN32FAST(x) __FAST32 __STRINGIFY(x)

#define PRId32		__PRI32(d)
#define PRIi32		__PRI32(i)
#define PRIo32		__PRI32(o)
#define PRIu32		__PRI32(u)
#define PRIx32		__PRI32(x)
#define PRIX32		__PRI32(X)

#define SCNd32		__SCN32(d)
#define SCNi32		__SCN32(i)
#define SCNo32		__SCN32(o)
#define SCNu32		__SCN32(u)
#define SCNx32		__SCN32(x)


#define PRIdLEAST32	__PRI32LEAST(d)
#define PRIiLEAST32	__PRI32LEAST(i)
#define PRIoLEAST32	__PRI32LEAST(o)
#define PRIuLEAST32	__PRI32LEAST(u)
#define PRIxLEAST32	__PRI32LEAST(x)
#define PRIXLEAST32	__PRI32LEAST(X)

#define SCNdLEAST32	__SCN32LEAST(d)
#define SCNiLEAST32	__SCN32LEAST(i)
#define SCNoLEAST32	__SCN32LEAST(o)
#define SCNuLEAST32	__SCN32LEAST(u)
#define SCNxLEAST32	__SCN32LEAST(x)


#define PRIdFAST32	__PRI32FAST(d)
#define PRIiFAST32	__PRI32FAST(i)
#define PRIoFAST32	__PRI32FAST(o)
#define PRIuFAST32	__PRI32FAST(u)
#define PRIxFAST32	__PRI32FAST(x)
#define PRIXFAST32	__PRI32FAST(X)

#define SCNdFAST32	__SCN32FAST(d)
#define SCNiFAST32	__SCN32FAST(i)
#define SCNoFAST32	__SCN32FAST(o)
#define SCNuFAST32	__SCN32FAST(u)
#define SCNxFAST32	__SCN32FAST(x)


/* 64-bit types */
#define __PRI64(x) __INT64 __STRINGIFY(x)
#define __SCN64(x) __INT64 __STRINGIFY(x)

#define __PRI64LEAST(x) __LEAST64 __STRINGIFY(x)
#define __SCN64LEAST(x) __LEAST64 __STRINGIFY(x)
#define __PRI64FAST(x) __FAST64 __STRINGIFY(x)
#define __SCN64FAST(x) __FAST64 __STRINGIFY(x)

#if 0 /* disabled by -frewrite-includes */
#if __int64_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 217 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define PRId64		__PRI64(d)
#define PRIi64		__PRI64(i)
#define PRIo64		__PRI64(o)
#define PRIu64		__PRI64(u)
#define PRIx64		__PRI64(x)
#define PRIX64		__PRI64(X)

#define SCNd64		__SCN64(d)
#define SCNi64		__SCN64(i)
#define SCNo64		__SCN64(o)
#define SCNu64		__SCN64(u)
#define SCNx64		__SCN64(x)
#endif
# 230 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __int_least64_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 232 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define PRIdLEAST64	__PRI64LEAST(d)
#define PRIiLEAST64	__PRI64LEAST(i)
#define PRIoLEAST64	__PRI64LEAST(o)
#define PRIuLEAST64	__PRI64LEAST(u)
#define PRIxLEAST64	__PRI64LEAST(x)
#define PRIXLEAST64	__PRI64LEAST(X)

#define SCNdLEAST64	__SCN64LEAST(d)
#define SCNiLEAST64	__SCN64LEAST(i)
#define SCNoLEAST64	__SCN64LEAST(o)
#define SCNuLEAST64	__SCN64LEAST(u)
#define SCNxLEAST64	__SCN64LEAST(x)
#endif
# 245 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __int_fast64_t_defined
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 247 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define PRIdFAST64	__PRI64FAST(d)
#define PRIiFAST64	__PRI64FAST(i)
#define PRIoFAST64	__PRI64FAST(o)
#define PRIuFAST64	__PRI64FAST(u)
#define PRIxFAST64	__PRI64FAST(x)
#define PRIXFAST64	__PRI64FAST(X)

#define SCNdFAST64	__SCN64FAST(d)
#define SCNiFAST64	__SCN64FAST(i)
#define SCNoFAST64	__SCN64FAST(o)
#define SCNuFAST64	__SCN64FAST(u)
#define SCNxFAST64	__SCN64FAST(x)
#endif
# 260 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

/* max-bit types */
#if 0 /* disabled by -frewrite-includes */
#if __have_long64
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 263 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define __PRIMAX(x) __STRINGIFY(l##x)
#define __SCNMAX(x) __STRINGIFY(l##x)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __have_longlong64
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 266 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define __PRIMAX(x) __STRINGIFY(ll##x)
#define __SCNMAX(x) __STRINGIFY(ll##x)
#else
# 269 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#define __PRIMAX(x) __STRINGIFY(x)
#define __SCNMAX(x) __STRINGIFY(x)
#endif
# 272 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#define PRIdMAX		__PRIMAX(d)
#define PRIiMAX		__PRIMAX(i)
#define PRIoMAX		__PRIMAX(o)
#define PRIuMAX		__PRIMAX(u)
#define PRIxMAX		__PRIMAX(x)
#define PRIXMAX		__PRIMAX(X)

#define SCNdMAX		__SCNMAX(d)
#define SCNiMAX		__SCNMAX(i)
#define SCNoMAX		__SCNMAX(o)
#define SCNuMAX		__SCNMAX(u)
#define SCNxMAX		__SCNMAX(x)

/* ptr types */
#if 0 /* disabled by -frewrite-includes */
#if defined (_INTPTR_EQ_LONGLONG)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 288 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# define __PRIPTR(x) __STRINGIFY(ll##x)
# define __SCNPTR(x) __STRINGIFY(ll##x)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined (_INTPTR_EQ_LONG)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 291 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# define __PRIPTR(x) __STRINGIFY(l##x)
# define __SCNPTR(x) __STRINGIFY(l##x)
#else
# 294 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
# define __PRIPTR(x) __STRINGIFY(x)
# define __SCNPTR(x) __STRINGIFY(x)
#endif
# 297 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#define PRIdPTR		__PRIPTR(d)
#define PRIiPTR		__PRIPTR(i)
#define PRIoPTR		__PRIPTR(o)
#define PRIuPTR		__PRIPTR(u)
#define PRIxPTR		__PRIPTR(x)
#define PRIXPTR		__PRIPTR(X)

#define SCNdPTR		__SCNPTR(d)
#define SCNiPTR		__SCNPTR(i)
#define SCNoPTR		__SCNPTR(o)
#define SCNuPTR		__SCNPTR(u)
#define SCNxPTR		__SCNPTR(x)


typedef struct {
  intmax_t	quot;
  intmax_t	rem;
} imaxdiv_t;

struct _reent;

#ifdef __cplusplus
extern "C" {
#endif
# 322 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

extern intmax_t  imaxabs(intmax_t);
extern imaxdiv_t imaxdiv(intmax_t __numer, intmax_t __denomer);
extern intmax_t  strtoimax(const char *__restrict, char **__restrict, int);
extern intmax_t  _strtoimax_r(struct _reent *, const char *__restrict, char **__restrict, int);
extern uintmax_t strtoumax(const char *__restrict, char **__restrict, int);
extern uintmax_t _strtoumax_r(struct _reent *, const char *__restrict, char **__restrict, int);
extern intmax_t  wcstoimax(const wchar_t *__restrict, wchar_t **__restrict, int);
extern intmax_t  _wcstoimax_r(struct _reent *, const wchar_t *__restrict, wchar_t **__restrict, int);
extern uintmax_t wcstoumax(const wchar_t *__restrict, wchar_t **__restrict, int);
extern uintmax_t _wcstoumax_r(struct _reent *, const wchar_t *__restrict, wchar_t **__restrict, int);

#if 0 /* disabled by -frewrite-includes */
#if __BSD_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 335 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
extern intmax_t  strtoimax_l(const char *__restrict, char **_restrict, int, locale_t);
extern uintmax_t strtoumax_l(const char *__restrict, char **_restrict, int, locale_t);
extern intmax_t  wcstoimax_l(const wchar_t *__restrict, wchar_t **_restrict, int, locale_t);
extern uintmax_t wcstoumax_l(const wchar_t *__restrict, wchar_t **_restrict, int, locale_t);
#endif
# 340 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#ifdef __cplusplus
}
#endif
# 344 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3

#endif
# 346 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/inttypes.h" 3
#endif /* inttypes.h expanded by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 2 3

#if 0 /* disabled by -frewrite-includes */
#if defined(_MSC_VER) && _MSC_VER < 1900
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 27 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
/* MSVC headers define int32_t as int, but PRIx32 as "lx" instead of "x".
 * This triggers format warnings, so fix it up here. */
#undef PRId32
#undef PRIdLEAST32
#undef PRIdFAST32
#undef PRIi32
#undef PRIiLEAST32
#undef PRIiFAST32
#undef PRIo32
#undef PRIoLEAST32
#undef PRIoFAST32
#undef PRIu32
#undef PRIuLEAST32
#undef PRIuFAST32
#undef PRIx32
#undef PRIxLEAST32
#undef PRIxFAST32
#undef PRIX32
#undef PRIXLEAST32
#undef PRIXFAST32

#undef SCNd32
#undef SCNdLEAST32
#undef SCNdFAST32
#undef SCNi32
#undef SCNiLEAST32
#undef SCNiFAST32
#undef SCNo32
#undef SCNoLEAST32
#undef SCNoFAST32
#undef SCNu32
#undef SCNuLEAST32
#undef SCNuFAST32
#undef SCNx32
#undef SCNxLEAST32
#undef SCNxFAST32

#define PRId32 "d"
#define PRIdLEAST32 "d"
#define PRIdFAST32 "d"
#define PRIi32 "i"
#define PRIiLEAST32 "i"
#define PRIiFAST32 "i"
#define PRIo32 "o"
#define PRIoLEAST32 "o"
#define PRIoFAST32 "o"
#define PRIu32 "u"
#define PRIuLEAST32 "u"
#define PRIuFAST32 "u"
#define PRIx32 "x"
#define PRIxLEAST32 "x"
#define PRIxFAST32 "x"
#define PRIX32 "X"
#define PRIXLEAST32 "X"
#define PRIXFAST32 "X"

#define SCNd32 "d"
#define SCNdLEAST32 "d"
#define SCNdFAST32 "d"
#define SCNi32 "i"
#define SCNiLEAST32 "i"
#define SCNiFAST32 "i"
#define SCNo32 "o"
#define SCNoLEAST32 "o"
#define SCNoFAST32 "o"
#define SCNu32 "u"
#define SCNuLEAST32 "u"
#define SCNuFAST32 "u"
#define SCNx32 "x"
#define SCNxLEAST32 "x"
#define SCNxFAST32 "x"
#endif
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3

#endif /* __MVS__ */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#endif /* __CLANG_INTTYPES_H */
# 102 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/inttypes.h" 3
#endif /* inttypes.h expanded by -frewrite-includes */
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h" 2
#if defined(__CLANG_REWRITTEN_INCLUDES) /* printing.h expanded by -frewrite-includes */
#include <printing.h>
#else /* printing.h expanded by -frewrite-includes */
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h" 1
#ifndef SUPPORT_PRINTING_H
#define SUPPORT_PRINTING_H

#if defined(__CLANG_REWRITTEN_INCLUDES) /* target.h expanded by -frewrite-includes */
#include "target.h"
#else /* target.h expanded by -frewrite-includes */
# 4 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h" 1
#ifndef LIB_TARGETS_TARGET_H
#define LIB_TARGETS_TARGET_H

#if 0 /* expanded by -frewrite-includes */
#include <stdint.h>
#endif /* expanded by -frewrite-includes */
# 4 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stdio.h expanded by -frewrite-includes */
#include <stdio.h>
#else /* stdio.h expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 1 3
/*
 * Copyright (c) 1990 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms are permitted
 * provided that the above copyright notice and this paragraph are
 * duplicated in all such forms and that any documentation,
 * and/or other materials related to such
 * distribution and use acknowledge that the software was developed
 * by the University of California, Berkeley.  The name of the
 * University may not be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 *	@(#)stdio.h	5.3 (Berkeley) 3/15/86
 */

/*
 * NB: to fit things in six character monocase externals, the
 * stdio code uses the prefix `__s' for stdio objects, typically
 * followed by a three-character attempt at a mnemonic.
 */

#ifndef _STDIO_H_
#define	_STDIO_H_

#if 0 /* expanded by -frewrite-includes */
#include "_ansi.h"
#endif /* expanded by -frewrite-includes */
# 29 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 30 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#define	_FSTDIO			/* ``function stdio'' */

#define __need_size_t
#define __need_NULL
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* cdefs.h expanded by -frewrite-includes */
#include <sys/cdefs.h>
#else /* cdefs.h expanded by -frewrite-includes */
# 35 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 1 3
/* libc/sys/linux/sys/cdefs.h - Helper macros for K&R vs. ANSI C compat. */

/* Written 2000 by Werner Almesberger */

/*-
 * SPDX-License-Identifier: BSD-3-Clause
 *
 * Copyright (c) 1991, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Berkeley Software Design, Inc.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)cdefs.h	8.8 (Berkeley) 1/9/95
 * $FreeBSD$
 */

#ifndef	_SYS_CDEFS_H_
#define	_SYS_CDEFS_H_

#if 0 /* expanded by -frewrite-includes */
#include <machine/_default_types.h>
#endif /* expanded by -frewrite-includes */
# 45 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
# 46 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/features.h>
#endif /* expanded by -frewrite-includes */
# 46 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
# 47 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stddef.h expanded by -frewrite-includes */
#include <stddef.h>
#else /* stddef.h expanded by -frewrite-includes */
# 47 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 1 3
/*===---- stddef.h - Basic type definitions --------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stddef.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stddef.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#undef __need_size_t
#undef __need_rsize_t
#undef __need_wchar_t
#undef __need_NULL
#undef __need_nullptr_t
#undef __need_unreachable
#undef __need_max_align_t
#undef __need_offsetof
#undef __need_wint_t
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stddef.h>
#endif /* expanded by -frewrite-includes */
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#else
# 37 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__need_ptrdiff_t) && !defined(__need_size_t) &&                   \
    !defined(__need_rsize_t) && !defined(__need_wchar_t) &&                    \
    !defined(__need_NULL) && !defined(__need_nullptr_t) &&                     \
    !defined(__need_unreachable) && !defined(__need_max_align_t) &&            \
    !defined(__need_offsetof) && !defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 43 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_ptrdiff_t
#define __need_size_t
/* ISO9899:2011 7.20 (C11 Annex K): Define rsize_t if __STDC_WANT_LIB_EXT1__ is
 * enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_rsize_t
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_wchar_t
#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDDEF_H) || __has_feature(modules)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
/*
 * __stddef_null.h is special when building without modules: if __need_NULL is
 * set, then it will unconditionally redefine NULL. To avoid stepping on client
 * definitions of NULL, __need_NULL should only be set the first time this
 * header is included, that is when __STDDEF_H is not defined. However, when
 * building with modules, this header is a textual header and needs to
 * unconditionally include __stdef_null.h to support multiple submodules
 * exporting _Builtin_stddef.null. Take module SM with submodules A and B, whose
 * headers both include stddef.h When SM.A builds, __STDDEF_H will be defined.
 * When SM.B builds, the definition from SM.A will leak when building without
 * local submodule visibility. stddef.h wouldn't include __stddef_null.h, and
 * SM.B wouldn't import _Builtin_stddef.null, and SM.B's `export *` wouldn't
 * export NULL as expected. When building with modules, always include
 * __stddef_null.h so that everything works as expected.
 */
#define __need_NULL
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) ||              \
    defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_nullptr_t
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_unreachable
#endif
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 78 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_max_align_t
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_offsetof
/* wint_t is provided by <wchar.h> and not <stddef.h>. It's here
 * for compatibility, but must be explicitly requested. Therefore
 * __need_wint_t is intentionally not defined here. */
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 85 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_ptrdiff_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_ptrdiff_t.h>
#endif /* expanded by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 89 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#endif /* defined(__need_ptrdiff_t) */
# 91 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_size_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_size_t.h expanded by -frewrite-includes */
#include <__stddef_size_t.h>
#else /* __stddef_size_t.h expanded by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 1 3
/*===---- __stddef_size_t.h - Definition of size_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_SIZE_T) ||                                                       \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#define _SIZE_T

typedef __SIZE_TYPE__ size_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#endif /* __stddef_size_t.h expanded by -frewrite-includes */
# 94 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_size_t
#endif /*defined(__need_size_t) */
# 96 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_rsize_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_rsize_t.h>
#endif /* expanded by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_rsize_t
#endif /* defined(__need_rsize_t) */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wchar_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wchar_t.h>
#endif /* expanded by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 104 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wchar_t
#endif /* defined(__need_wchar_t) */
# 106 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_NULL)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_null.h expanded by -frewrite-includes */
#include <__stddef_null.h>
#else /* __stddef_null.h expanded by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 1 3
/*===---- __stddef_null.h - Definition of NULL -----------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(NULL) || !__building_module(_Builtin_stddef)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3

/* linux/stddef.h will define NULL to 0. glibc (and other) headers then define
 * __need_NULL and rely on stddef.h to redefine NULL to the correct value again.
 * Modules don't support redefining macros like that, but support that pattern
 * in the non-modules case.
 */
#undef NULL

#ifdef __cplusplus
#if 0 /* disabled by -frewrite-includes */
#if !defined(__MINGW32__) && !defined(_MSC_VER)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#define NULL __null
#else
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#define NULL 0
#endif
# 25 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#else
# 26 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#define NULL ((void*)0)
#endif
# 28 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3

#endif
# 30 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_null.h" 3
#endif /* __stddef_null.h expanded by -frewrite-includes */
# 109 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_NULL
#endif /* defined(__need_NULL) */
# 111 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_nullptr_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_nullptr_t.h>
#endif /* expanded by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 114 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_nullptr_t
#endif /* defined(__need_nullptr_t) */
# 116 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_unreachable.h>
#endif /* expanded by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 119 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_unreachable
#endif /* defined(__need_unreachable) */
# 121 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_max_align_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_max_align_t.h>
#endif /* expanded by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 124 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_max_align_t
#endif /* defined(__need_max_align_t) */
# 126 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_offsetof)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_offsetof.h>
#endif /* expanded by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 129 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_offsetof
#endif /* defined(__need_offsetof) */
# 131 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

/* Some C libraries expect to see a wint_t here. Others (notably MinGW) will use
__WINT_TYPE__ directly; accommodate both by requiring __need_wint_t */
#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wint_t.h>
#endif /* expanded by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 136 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wint_t
#endif /* __need_wint_t */
# 138 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#endif /* __MVS__ */
# 140 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif /* stddef.h expanded by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 2 3

#define __PMT(args)	args
#define __DOTS    	, ...
#define __THROW

#ifdef __GNUC__
# define __ASMNAME(cname)  __XSTRING (__USER_LABEL_PREFIX__) cname
#endif
# 56 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#define __ptr_t void *
#define __long_double_t  long double

#define __attribute_malloc__
#define __attribute_pure__
#define __attribute_format_strfmon__(a,b)
#define __flexarr      [0]

#ifndef __BOUNDED_POINTERS__
# define __bounded      /* nothing */
# define __unbounded    /* nothing */
# define __ptrvalue     /* nothing */
#endif
# 70 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Testing against Clang-specific extensions.
 */
#ifndef	__has_attribute
#define	__has_attribute(x)	0
#endif
# 77 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#ifndef	__has_extension
#define	__has_extension		__has_feature
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#ifndef	__has_feature
#define	__has_feature(x)	0
#endif
# 83 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#ifndef	__has_include
#define	__has_include(x)	0
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#ifndef	__has_builtin
#define	__has_builtin(x)	0
#endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 91 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__BEGIN_DECLS	extern "C" {
#define	__END_DECLS	}
#else
# 94 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__BEGIN_DECLS
#define	__END_DECLS
#endif
# 97 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * This code has been put in place to help reduce the addition of
 * compiler specific defines in FreeBSD code.  It helps to aid in
 * having a compiler-agnostic source tree.
 */

#if 0 /* disabled by -frewrite-includes */
#if defined(__GNUC__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 105 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC__ >= 3
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 107 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__GNUCLIKE_ASM 3
#define	__GNUCLIKE_MATH_BUILTIN_CONSTANTS
#else
# 110 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__GNUCLIKE_ASM 2
#endif
# 112 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__GNUCLIKE___TYPEOF 1
#define	__GNUCLIKE___SECTION 1

#define	__GNUCLIKE_CTOR_SECTION_HANDLING 1

#define	__GNUCLIKE_BUILTIN_CONSTANT_P 1

#if 0 /* disabled by -frewrite-includes */
#if (__GNUC_MINOR__ > 95 || __GNUC__ >= 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 120 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__GNUCLIKE_BUILTIN_VARARGS 1
#define	__GNUCLIKE_BUILTIN_STDARG 1
#define	__GNUCLIKE_BUILTIN_VAALIST 1
#endif
# 124 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#define	__GNUC_VA_LIST_COMPATIBILITY 1

/*
 * Compiler memory barriers, specific to gcc and clang.
 */
#define	__compiler_membar()	__asm __volatile(" " : : : "memory")

#define	__GNUCLIKE_BUILTIN_NEXT_ARG 1
#define	__GNUCLIKE_MATH_BUILTIN_RELOPS

#define	__GNUCLIKE_BUILTIN_MEMCPY 1

/* XXX: if __GNUC__ >= 2: not tested everywhere originally, where replaced */
#define	__CC_SUPPORTS_INLINE 1
#define	__CC_SUPPORTS___INLINE 1
#define	__CC_SUPPORTS___INLINE__ 1

#define	__CC_SUPPORTS___FUNC__ 1
#define	__CC_SUPPORTS_WARNING 1

#define	__CC_SUPPORTS_VARADIC_XXX 1 /* see varargs.h */

#define	__CC_SUPPORTS_DYNAMIC_ARRAY_INIT 1

#endif /* __GNUC__ */
# 150 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * The __CONCAT macro is used to concatenate parts of symbol names, e.g.
 * with "#define OLD(foo) __CONCAT(old,foo)", OLD(foo) produces oldfoo.
 * The __CONCAT macro is a bit tricky to use if it must work in non-ANSI
 * mode -- there must be no spaces between its arguments, and for nested
 * __CONCAT's, all the __CONCAT's must be at the left.  __CONCAT can also
 * concatenate double-quoted strings produced by the __STRING macro, but
 * this only works with ANSI C.
 *
 * __XSTRING is like __STRING, but it expands any macros in its argument
 * first.  It is only available with ANSI C.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC__) || defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 164 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__P(protos)	protos		/* full-blown ANSI C */
#define	__CONCAT1(x,y)	x ## y
#define	__CONCAT(x,y)	__CONCAT1(x,y)
#define	__STRING(x)	#x		/* stringify without expanding x */
#define	__XSTRING(x)	__STRING(x)	/* expand x, then stringify */

#define	__const		const		/* define reserved names to standard */
#define	__signed	signed
#define	__volatile	volatile
#if 0 /* disabled by -frewrite-includes */
#if defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 174 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__inline	inline		/* convert to C++ keyword */
#else
# 176 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if !(defined(__CC_SUPPORTS___INLINE))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 177 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__inline			/* delete GCC keyword */
#endif /* ! __CC_SUPPORTS___INLINE */
# 179 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif /* !__cplusplus */
# 180 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#else	/* !(__STDC__ || __cplusplus) */
# 182 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__P(protos)	()		/* traditional C preprocessor */
#define	__CONCAT(x,y)	x/**/y
#define	__STRING(x)	"x"

#if 0 /* disabled by -frewrite-includes */
#if !defined(__CC_SUPPORTS___INLINE)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 187 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__const				/* delete pseudo-ANSI C keywords */
#define	__inline
#define	__signed
#define	__volatile
/*
 * In non-ANSI C environments, new programs will want ANSI-only C keywords
 * deleted from the program and old programs will want them left alone.
 * When using a compiler other than gcc, programs using the ANSI C keywords
 * const, inline etc. as normal identifiers should define -DNO_ANSI_KEYWORDS.
 * When using "gcc -traditional", we assume that this is the intent; if
 * __GNUC__ is defined but __STDC__ is not, we leave the new keywords alone.
 */
#ifndef	NO_ANSI_KEYWORDS
#define	const				/* delete ANSI C keywords */
#define	inline
#define	signed
#define	volatile
#endif	/* !NO_ANSI_KEYWORDS */
# 205 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif	/* !__CC_SUPPORTS___INLINE */
# 206 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif	/* !(__STDC__ || __cplusplus) */
# 207 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Compiler-dependent macros to help declare dead (non-returning) and
 * pure (no side effects) functions, and unused variables.  They are
 * null except for versions of gcc that are known to support the features
 * properly (old versions of gcc-2 supported the dead and pure features
 * in a different (wrong) way).  If we do not provide an implementation
 * for a given compiler, let the compile fail if it is told to use
 * a feature that we cannot live without.
 */
#define	__weak_symbol	__attribute__((__weak__))
#if 0 /* disabled by -frewrite-includes */
#if !__GNUC_PREREQ__(2, 5)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 219 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__dead2
#define	__pure2
#define	__unused
#endif
# 223 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNUC__ == 2 && __GNUC_MINOR__ >= 5 && __GNUC_MINOR__ < 7
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 224 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__dead2		__attribute__((__noreturn__))
#define	__pure2		__attribute__((__const__))
#define	__unused
/* XXX Find out what to do for __packed, __aligned and __section */
#endif
# 229 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(2, 7)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 230 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__dead2		__attribute__((__noreturn__))
#define	__pure2		__attribute__((__const__))
#define	__unused	__attribute__((__unused__))
#define	__used		__attribute__((__used__))
#define	__packed	__attribute__((__packed__))
#define	__aligned(x)	__attribute__((__aligned__(x)))
#define	__section(x)	__attribute__((__section__(x)))
#endif
# 238 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(4, 3) || __has_attribute(__alloc_size__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 239 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__alloc_size(x)	__attribute__((__alloc_size__(x)))
#define	__alloc_size2(n, x)	__attribute__((__alloc_size__(n, x)))
#else
# 242 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__alloc_size(x)
#define	__alloc_size2(n, x)
#endif
# 245 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(4, 9) || __has_attribute(__alloc_align__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 246 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__alloc_align(x)	__attribute__((__alloc_align__(x)))
#else
# 248 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__alloc_align(x)
#endif
# 250 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__GNUC_PREREQ__(2, 95)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 252 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__alignof(x)	__offsetof(struct { char __a; x __b; }, __b)
#endif
# 254 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Keywords added in C11.
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDC_VERSION__) || __STDC_VERSION__ < 201112L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 260 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__has_extension(c_alignas)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 262 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__cplusplus) && __cplusplus >= 201103L) || \
    __has_extension(cxx_alignas)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 264 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Alignas(x)		alignas(x)
#else
# 266 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
/* XXX: Only emulates _Alignas(constant-expression); not _Alignas(type-name). */
#define	_Alignas(x)		__aligned(x)
#endif
# 269 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif
# 270 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__cplusplus) && __cplusplus >= 201103L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 272 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Alignof(x)		alignof(x)
#else
# 274 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Alignof(x)		__alignof(x)
#endif
# 276 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__cplusplus) && !__has_extension(c_atomic) && \
	!__has_extension(cxx_atomic) && !__GNUC_PREREQ__(4, 7)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 279 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
/*
 * No native support for _Atomic(). Place object in structure to prevent
 * most forms of direct non-atomic access.
 */
#define	_Atomic(T)		struct { T volatile __val; }
#endif
# 285 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__cplusplus) && __cplusplus >= 201103L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 287 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Noreturn		[[noreturn]]
#else
# 289 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Noreturn		__dead2
#endif
# 291 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__has_extension(c_static_assert)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 293 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__cplusplus) && __cplusplus >= 201103L) || \
    __has_extension(cxx_static_assert)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 295 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Static_assert(x, y)	static_assert(x, y)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __GNUC_PREREQ__(4,6) && !defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 297 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
/* Nothing, gcc 4.6 and higher has _Static_assert built-in */
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(__COUNTER__)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 299 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Static_assert(x, y)	__Static_assert(x, __COUNTER__)
#define	__Static_assert(x, y)	___Static_assert(x, y)
#define	___Static_assert(x, y)	typedef char __assert_ ## y[(x) ? 1 : -1] \
				__unused
#else
# 304 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Static_assert(x, y)	struct __hack
#endif
# 306 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif
# 307 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !__has_extension(c_thread_local)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 309 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
/*
 * XXX: Some compilers (Clang 3.3, GCC 4.7) falsely announce C++11 mode
 * without actually supporting the thread_local keyword. Don't check for
 * the presence of C++11 when defining _Thread_local.
 */
#if 0 /* disabled by -frewrite-includes */
#if /* (defined(__cplusplus) && __cplusplus >= 201103L) || */ \
    __has_extension(cxx_thread_local)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 316 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Thread_local		thread_local
#else
# 318 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Thread_local		__thread
#endif
# 320 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif
# 321 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#endif /* __STDC_VERSION__ || __STDC_VERSION__ < 201112L */
# 323 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Emulation of C11 _Generic().  Unlike the previously defined C11
 * keywords, it is not possible to implement this using exactly the same
 * syntax.  Therefore implement something similar under the name
 * __generic().  Unlike _Generic(), this macro can only distinguish
 * between a single type, so it requires nested invocations to
 * distinguish multiple cases.
 *
 * Note that the comma operator is used to force expr to decay in
 * order to match _Generic().
 */

#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) || \
    __has_extension(c_generic_selections)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 338 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__generic(expr, t, yes, no)					\
	_Generic(expr, t: yes, default: no)
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __GNUC_PREREQ__(3, 1) && !defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 341 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__generic(expr, t, yes, no)					\
	__builtin_choose_expr(						\
	    __builtin_types_compatible_p(__typeof((0, (expr))), t), yes, no)
#endif
# 345 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * C99 Static array indices in function parameter declarations.  Syntax such as:
 * void bar(int myArray[static 10]);
 * is allowed in C99 but not in C++.  Define __min_size appropriately so
 * headers using it can be compiled in either language.  Use like this:
 * void bar(int myArray[__min_size(10)]);
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(__cplusplus) && \
    (defined(__clang__) || __GNUC_PREREQ__(4, 6)) && \
    (!defined(__STDC_VERSION__) || (__STDC_VERSION__ >= 199901))
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 356 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __min_size(x)	static (x)
#else
# 358 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __min_size(x)	(x)
#endif
# 360 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(2, 96)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 362 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__malloc_like	__attribute__((__malloc__))
#define	__pure		__attribute__((__pure__))
#else
# 365 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__malloc_like
#define	__pure
#endif
# 368 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(3, 1)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 370 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__always_inline	__inline__ __attribute__((__always_inline__))
#else
# 372 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__always_inline
#endif
# 374 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(3, 1)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 376 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__noinline	__attribute__ ((__noinline__))
#else
# 378 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__noinline
#endif
# 380 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(3, 3)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 382 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__nonnull(x)	__attribute__((__nonnull__ x))
#define	__nonnull_all	__attribute__((__nonnull__))
#else
# 385 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__nonnull(x)
#define	__nonnull_all
#endif
# 388 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(3, 4)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 390 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__fastcall	__attribute__((__fastcall__))
#define	__result_use_check	__attribute__((__warn_unused_result__))
#else
# 393 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__fastcall
#define	__result_use_check
#endif
# 396 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(4, 1)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 398 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__returns_twice	__attribute__((__returns_twice__))
#else
# 400 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__returns_twice
#endif
# 402 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(4, 6) || __has_builtin(__builtin_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 404 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__unreachable()	__builtin_unreachable()
#else
# 406 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__unreachable()	((void)0)
#endif
# 408 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/* XXX: should use `#if __STDC_VERSION__ < 199901'. */
#if 0 /* disabled by -frewrite-includes */
#if !__GNUC_PREREQ__(2, 7)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 411 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__func__	NULL
#endif
# 413 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * We use `__restrict' as a way to define the `restrict' type qualifier
 * without disturbing older software that is unaware of C99 keywords.
 * GCC also provides `__restrict' as an extension to support C99-style
 * restricted pointers in other language modes.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 421 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__restrict	restrict
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif !__GNUC_PREREQ__(2, 95)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 423 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__restrict
#endif
# 425 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Additionally, we allow to use `__restrict_arr' for declaring arrays as
 * non-overlapping per C99.  That's supported since gcc 3.1, but it's not
 * allowed in C++.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__cplusplus) || !__GNUC_PREREQ__(3, 1)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 432 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __restrict_arr
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined __STDC_VERSION__ && __STDC_VERSION__ >= 199901L
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 434 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __restrict_arr       restrict
#else
# 436 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __restrict_arr
#endif
# 438 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * GNU C version 2.96 adds explicit branch prediction so that
 * the CPU back-end can hint the processor and also so that
 * code blocks can be reordered such that the predicted path
 * sees a more linear flow, thus improving cache behavior, etc.
 *
 * The following two macros provide us with a way to utilize this
 * compiler feature.  Use __predict_true() if you expect the expression
 * to evaluate to true, and __predict_false() if you expect the
 * expression to evaluate to false.
 *
 * A few notes about usage:
 *
 *	* Generally, __predict_false() error condition checks (unless
 *	  you have some _strong_ reason to do otherwise, in which case
 *	  document it), and/or __predict_true() `no-error' condition
 *	  checks, assuming you want to optimize for the no-error case.
 *
 *	* Other than that, if you don't know the likelihood of a test
 *	  succeeding from empirical or other `hard' evidence, don't
 *	  make predictions.
 *
 *	* These are meant to be used in places that are run `a lot'.
 *	  It is wasteful to make predictions in code that is run
 *	  seldomly (e.g. at subsystem initialization time) as the
 *	  basic block reordering that this affects can often generate
 *	  larger code.
 */
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(2, 96)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 468 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__predict_true(exp)     __builtin_expect((exp), 1)
#define	__predict_false(exp)    __builtin_expect((exp), 0)
#else
# 471 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__predict_true(exp)     (exp)
#define	__predict_false(exp)    (exp)
#endif
# 474 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(4, 0)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 476 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__null_sentinel	__attribute__((__sentinel__))
#define	__exported	__attribute__((__visibility__("default")))
/* Only default visibility is supported on PE/COFF targets. */
#ifndef __CYGWIN__
#define	__hidden	__attribute__((__visibility__("hidden")))
#else
# 482 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__hidden
#endif
# 484 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#else
# 485 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__null_sentinel
#define	__exported
#define	__hidden
#endif
# 489 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#define __offsetof(type, field)	offsetof(type, field)
#define	__rangeof(type, start, end) \
	(__offsetof(type, end) - __offsetof(type, start))

/*
 * Given the pointer x to the member m of the struct s, return
 * a pointer to the containing structure.  When using GCC, we first
 * assign pointer x to a local variable, to check that its type is
 * compatible with member m.
 */
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_PREREQ__(3, 1)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 501 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__containerof(x, s, m) ({					\
	const volatile __typeof(((s *)0)->m) *__x = (x);		\
	__DEQUALIFY(s *, (const volatile char *)__x - __offsetof(s, m));\
})
#else
# 506 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__containerof(x, s, m)						\
	__DEQUALIFY(s *, (const volatile char *)(x) - __offsetof(s, m))
#endif
# 509 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Compiler-dependent macros to declare that functions take printf-like
 * or scanf-like arguments.  They are null except for versions of gcc
 * that are known to support the features properly (old versions of gcc-2
 * didn't permit keeping the keywords out of the application namespace).
 */
#if 0 /* disabled by -frewrite-includes */
#if !__GNUC_PREREQ__(2, 7)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 517 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__printflike(fmtarg, firstvararg)
#define	__scanflike(fmtarg, firstvararg)
#define	__format_arg(fmtarg)
#define	__strfmonlike(fmtarg, firstvararg)
#define	__strftimelike(fmtarg, firstvararg)
#else
# 523 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__printflike(fmtarg, firstvararg) \
	    __attribute__((__format__ (__printf__, fmtarg, firstvararg)))
#define	__scanflike(fmtarg, firstvararg) \
	    __attribute__((__format__ (__scanf__, fmtarg, firstvararg)))
#define	__format_arg(fmtarg)	__attribute__((__format_arg__ (fmtarg)))
#define	__strfmonlike(fmtarg, firstvararg) \
	    __attribute__((__format__ (__strfmon__, fmtarg, firstvararg)))
#define	__strftimelike(fmtarg, firstvararg) \
	    __attribute__((__format__ (__strftime__, fmtarg, firstvararg)))
#endif
# 533 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/* Compiler-dependent macros that rely on FreeBSD-specific extensions. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__FreeBSD_cc_version) && __FreeBSD_cc_version >= 300001 && \
    defined(__GNUC__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 537 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__printf0like(fmtarg, firstvararg) \
	    __attribute__((__format__ (__printf0__, fmtarg, firstvararg)))
#else
# 540 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__printf0like(fmtarg, firstvararg)
#endif
# 542 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__GNUC__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 544 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__strong_reference(sym,aliassym)	\
	extern __typeof (sym) aliassym __attribute__ ((__alias__ (#sym)))
#ifdef __ELF__
#ifdef __STDC__
#define	__weak_reference(sym,alias)	\
	__asm__(".weak " #alias);	\
	__asm__(".equ "  #alias ", " #sym)
#define	__warn_references(sym,msg)	\
	__asm__(".section .gnu.warning." #sym);	\
	__asm__(".asciz \"" msg "\"");	\
	__asm__(".previous")
#define	__sym_compat(sym,impl,verid)	\
	__asm__(".symver " #impl ", " #sym "@" #verid)
#define	__sym_default(sym,impl,verid)	\
	__asm__(".symver " #impl ", " #sym "@@" #verid)
#else
# 560 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__weak_reference(sym,alias)	\
	__asm__(".weak alias");		\
	__asm__(".equ alias, sym")
#define	__warn_references(sym,msg)	\
	__asm__(".section .gnu.warning.sym"); \
	__asm__(".asciz \"msg\"");	\
	__asm__(".previous")
#define	__sym_compat(sym,impl,verid)	\
	__asm__(".symver impl, sym@verid")
#define	__sym_default(impl,sym,verid)	\
	__asm__(".symver impl, sym@@verid")
#endif	/* __STDC__ */
# 572 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#else	/* !__ELF__ */
# 573 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#ifdef __STDC__
#define	__weak_reference(sym,alias)	\
	__asm__(".stabs \"_" #alias "\",11,0,0,0");	\
	__asm__(".stabs \"_" #sym "\",1,0,0,0")
#define	__warn_references(sym,msg)	\
	__asm__(".stabs \"" msg "\",30,0,0,0");		\
	__asm__(".stabs \"_" #sym "\",1,0,0,0")
#else
# 581 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__weak_reference(sym,alias)	\
	__asm__(".stabs \"_/**/alias\",11,0,0,0");	\
	__asm__(".stabs \"_/**/sym\",1,0,0,0")
#define	__warn_references(sym,msg)	\
	__asm__(".stabs msg,30,0,0,0");			\
	__asm__(".stabs \"_/**/sym\",1,0,0,0")
#endif	/* __STDC__ */
# 588 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif	/* __ELF__ */
# 589 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif	/* __GNUC__ */
# 590 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__FBSDID
#define	__FBSDID(s)	struct __hack
#endif
# 594 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__RCSID
#define	__RCSID(s)	struct __hack
#endif
# 598 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__RCSID_SOURCE
#define	__RCSID_SOURCE(s)	struct __hack
#endif
# 602 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__SCCSID
#define	__SCCSID(s)	struct __hack
#endif
# 606 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__COPYRIGHT
#define	__COPYRIGHT(s)	struct __hack
#endif
# 610 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__DECONST
#define	__DECONST(type, var)	((type)(__uintptr_t)(const void *)(var))
#endif
# 614 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__DEVOLATILE
#define	__DEVOLATILE(type, var)	((type)(__uintptr_t)(volatile void *)(var))
#endif
# 618 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#ifndef	__DEQUALIFY
#define	__DEQUALIFY(type, var)	((type)(__uintptr_t)(const volatile void *)(var))
#endif
# 622 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Nullability qualifiers: currently only supported by Clang.
 */
#if 0 /* disabled by -frewrite-includes */
#if !(defined(__clang__) && __has_feature(nullability))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 627 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	_Nonnull
#define	_Nullable
#define	_Null_unspecified
#define	__NULLABILITY_PRAGMA_PUSH
#define	__NULLABILITY_PRAGMA_POP
#else
# 633 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__NULLABILITY_PRAGMA_PUSH _Pragma("clang diagnostic push")	\
	_Pragma("clang diagnostic ignored \"-Wnullability-completeness\"")
#define	__NULLABILITY_PRAGMA_POP _Pragma("clang diagnostic pop")
#endif
# 637 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Type Safety Checking
 *
 * Clang provides additional attributes to enable checking type safety
 * properties that cannot be enforced by the C type system. 
 */

#if 0 /* disabled by -frewrite-includes */
#if __has_attribute(__argument_with_type_tag__) && \
    __has_attribute(__type_tag_for_datatype__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 647 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__arg_type_tag(arg_kind, arg_idx, type_tag_idx) \
	    __attribute__((__argument_with_type_tag__(arg_kind, arg_idx, type_tag_idx)))
#define	__datatype_type_tag(kind, type) \
	    __attribute__((__type_tag_for_datatype__(kind, type)))
#else
# 652 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__arg_type_tag(arg_kind, arg_idx, type_tag_idx)
#define	__datatype_type_tag(kind, type)
#endif
# 655 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/*
 * Lock annotations.
 *
 * Clang provides support for doing basic thread-safety tests at
 * compile-time, by marking which locks will/should be held when
 * entering/leaving a functions.
 *
 * Furthermore, it is also possible to annotate variables and structure
 * members to enforce that they are only accessed when certain locks are
 * held.
 */

#if 0 /* disabled by -frewrite-includes */
#if __has_extension(c_thread_safety_attributes)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 669 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__lock_annotate(x)	__attribute__((x))
#else
# 671 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define	__lock_annotate(x)
#endif
# 673 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/* Structure implements a lock. */
/* FIXME: Use __lockable__, etc. to avoid colliding with user namespace macros,
 * once clang is fixed: https://bugs.llvm.org/show_bug.cgi?id=34319 */
#define	__lockable		__lock_annotate(lockable)

/* Function acquires an exclusive or shared lock. */
#define	__locks_exclusive(...) \
	__lock_annotate(exclusive_lock_function(__VA_ARGS__))
#define	__locks_shared(...) \
	__lock_annotate(shared_lock_function(__VA_ARGS__))

/* Function attempts to acquire an exclusive or shared lock. */
#define	__trylocks_exclusive(...) \
	__lock_annotate(exclusive_trylock_function(__VA_ARGS__))
#define	__trylocks_shared(...) \
	__lock_annotate(shared_trylock_function(__VA_ARGS__))

/* Function releases a lock. */
#define	__unlocks(...)		__lock_annotate(unlock_function(__VA_ARGS__))

/* Function asserts that an exclusive or shared lock is held. */
#define	__asserts_exclusive(...) \
	__lock_annotate(assert_exclusive_lock(__VA_ARGS__))
#define	__asserts_shared(...) \
	__lock_annotate(assert_shared_lock(__VA_ARGS__))

/* Function requires that an exclusive or shared lock is or is not held. */
#define	__requires_exclusive(...) \
	__lock_annotate(exclusive_locks_required(__VA_ARGS__))
#define	__requires_shared(...) \
	__lock_annotate(shared_locks_required(__VA_ARGS__))
#define	__requires_unlocked(...) \
	__lock_annotate(locks_excluded(__VA_ARGS__))

/* Function should not be analyzed. */
#define	__no_lock_analysis	__lock_annotate(no_thread_safety_analysis)

/*
 * Function or variable should not be sanitized, e.g., by AddressSanitizer.
 * GCC has the nosanitize attribute, but as a function attribute only, and
 * warns on use as a variable attribute.
 */
#if 0 /* disabled by -frewrite-includes */
#if __has_attribute(no_sanitize) && defined(__clang__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 717 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#ifdef _KERNEL
#define __nosanitizeaddress	__attribute__((no_sanitize("kernel-address")))
#define __nosanitizememory	__attribute__((no_sanitize("kernel-memory")))
#else
# 721 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __nosanitizeaddress	__attribute__((no_sanitize("address")))
#define __nosanitizememory	__attribute__((no_sanitize("memory")))
#endif
# 724 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __nosanitizethread	__attribute__((no_sanitize("thread")))
#else
# 726 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __nosanitizeaddress
#define __nosanitizememory
#define __nosanitizethread
#endif
# 730 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

/* Guard variables and structure members by lock. */
#define	__guarded_by(x)		__lock_annotate(guarded_by(x))
#define	__pt_guarded_by(x)	__lock_annotate(pt_guarded_by(x))

/* Alignment builtins for better type checking and improved code generation. */
/* Provide fallback versions for other compilers (GCC/Clang < 10): */
#if 0 /* disabled by -frewrite-includes */
#if !__has_builtin(__builtin_is_aligned)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 738 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __builtin_is_aligned(x, align)	\
	(((__uintptr_t)x & ((align) - 1)) == 0)
#endif
# 741 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if !__has_builtin(__builtin_align_up)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 742 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __builtin_align_up(x, align)	\
	((__typeof__(x))(((__uintptr_t)(x)+((align)-1))&(~((align)-1))))
#endif
# 745 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#if 0 /* disabled by -frewrite-includes */
#if !__has_builtin(__builtin_align_down)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 746 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#define __builtin_align_down(x, align)	\
	((__typeof__(x))((x)&(~((align)-1))))
#endif
# 749 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3

#define __align_up(x, y) __builtin_align_up(x, y)
#define __align_down(x, y) __builtin_align_down(x, y)
#define __is_aligned(x, y) __builtin_is_aligned(x, y)

#endif /* !_SYS_CDEFS_H_ */
# 755 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/cdefs.h" 3
#endif /* cdefs.h expanded by -frewrite-includes */
# 36 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 2 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stddef.h expanded by -frewrite-includes */
#include <stddef.h>
#else /* stddef.h expanded by -frewrite-includes */
# 36 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 1 3
/*===---- stddef.h - Basic type definitions --------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stddef.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stddef.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#undef __need_size_t
#undef __need_rsize_t
#undef __need_wchar_t
#undef __need_NULL
#undef __need_nullptr_t
#undef __need_unreachable
#undef __need_max_align_t
#undef __need_offsetof
#undef __need_wint_t
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stddef.h>
#endif /* expanded by -frewrite-includes */
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#else
# 37 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__need_ptrdiff_t) && !defined(__need_size_t) &&                   \
    !defined(__need_rsize_t) && !defined(__need_wchar_t) &&                    \
    !defined(__need_NULL) && !defined(__need_nullptr_t) &&                     \
    !defined(__need_unreachable) && !defined(__need_max_align_t) &&            \
    !defined(__need_offsetof) && !defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 43 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_ptrdiff_t
#define __need_size_t
/* ISO9899:2011 7.20 (C11 Annex K): Define rsize_t if __STDC_WANT_LIB_EXT1__ is
 * enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_rsize_t
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_wchar_t
#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDDEF_H) || __has_feature(modules)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
/*
 * __stddef_null.h is special when building without modules: if __need_NULL is
 * set, then it will unconditionally redefine NULL. To avoid stepping on client
 * definitions of NULL, __need_NULL should only be set the first time this
 * header is included, that is when __STDDEF_H is not defined. However, when
 * building with modules, this header is a textual header and needs to
 * unconditionally include __stdef_null.h to support multiple submodules
 * exporting _Builtin_stddef.null. Take module SM with submodules A and B, whose
 * headers both include stddef.h When SM.A builds, __STDDEF_H will be defined.
 * When SM.B builds, the definition from SM.A will leak when building without
 * local submodule visibility. stddef.h wouldn't include __stddef_null.h, and
 * SM.B wouldn't import _Builtin_stddef.null, and SM.B's `export *` wouldn't
 * export NULL as expected. When building with modules, always include
 * __stddef_null.h so that everything works as expected.
 */
#define __need_NULL
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) ||              \
    defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_nullptr_t
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_unreachable
#endif
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 78 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_max_align_t
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_offsetof
/* wint_t is provided by <wchar.h> and not <stddef.h>. It's here
 * for compatibility, but must be explicitly requested. Therefore
 * __need_wint_t is intentionally not defined here. */
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 85 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_ptrdiff_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
#include <__stddef_ptrdiff_t.h>
#else /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 1 3
/*===---- __stddef_ptrdiff_t.h - Definition of ptrdiff_t -------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_PTRDIFF_T) ||                                                    \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 3
#define _PTRDIFF_T

typedef __PTRDIFF_TYPE__ ptrdiff_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 3
#endif /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
# 89 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_ptrdiff_t
#endif /* defined(__need_ptrdiff_t) */
# 91 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_size_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_size_t.h expanded by -frewrite-includes */
#include <__stddef_size_t.h>
#else /* __stddef_size_t.h expanded by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 1 3
/*===---- __stddef_size_t.h - Definition of size_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_SIZE_T) ||                                                       \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#define _SIZE_T

typedef __SIZE_TYPE__ size_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#endif /* __stddef_size_t.h expanded by -frewrite-includes */
# 94 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_size_t
#endif /*defined(__need_size_t) */
# 96 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_rsize_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_rsize_t.h>
#endif /* expanded by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_rsize_t
#endif /* defined(__need_rsize_t) */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wchar_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_wchar_t.h expanded by -frewrite-includes */
#include <__stddef_wchar_t.h>
#else /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 1 3
/*===---- __stddef_wchar.h - Definition of wchar_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(__cplusplus) || (defined(_MSC_VER) && !_NATIVE_WCHAR_T_DEFINED)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_WCHAR_T) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#define _WCHAR_T

#ifdef _MSC_EXTENSIONS
#define _WCHAR_T_DEFINED
#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

typedef __WCHAR_TYPE__ wchar_t;

#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

#endif
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#endif /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_wchar_t
#endif /* defined(__need_wchar_t) */
# 106 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_NULL)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_null.h>
#endif /* expanded by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 109 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_NULL
#endif /* defined(__need_NULL) */
# 111 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_nullptr_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_nullptr_t.h>
#endif /* expanded by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 114 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_nullptr_t
#endif /* defined(__need_nullptr_t) */
# 116 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_unreachable.h>
#endif /* expanded by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 119 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_unreachable
#endif /* defined(__need_unreachable) */
# 121 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_max_align_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_max_align_t.h>
#endif /* expanded by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 124 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_max_align_t
#endif /* defined(__need_max_align_t) */
# 126 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_offsetof)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_offsetof.h expanded by -frewrite-includes */
#include <__stddef_offsetof.h>
#else /* __stddef_offsetof.h expanded by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 1 3
/*===---- __stddef_offsetof.h - Definition of offsetof ---------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(offsetof) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 3
#define offsetof(t, d) __builtin_offsetof(t, d)
#endif
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 3
#endif /* __stddef_offsetof.h expanded by -frewrite-includes */
# 129 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_offsetof
#endif /* defined(__need_offsetof) */
# 131 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

/* Some C libraries expect to see a wint_t here. Others (notably MinGW) will use
__WINT_TYPE__ directly; accommodate both by requiring __need_wint_t */
#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wint_t.h>
#endif /* expanded by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 136 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wint_t
#endif /* __need_wint_t */
# 138 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#endif /* __MVS__ */
# 140 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif /* stddef.h expanded by -frewrite-includes */
# 37 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 2 3

/* typedef only __gnuc_va_list, used throughout the header */
#define __need___va_list
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stdarg.h expanded by -frewrite-includes */
#include <stdarg.h>
#else /* stdarg.h expanded by -frewrite-includes */
# 40 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 1 3
/*===---- stdarg.h - Variable argument handling ----------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stdarg.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stdarg.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need___va_list
#undef __need_va_list
#undef __need_va_arg
#undef __need___va_copy
#undef __need_va_copy
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 28 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stdarg.h>
#endif /* expanded by -frewrite-includes */
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 30 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#else
# 32 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#if 0 /* disabled by -frewrite-includes */
#if !defined(__need___va_list) && !defined(__need_va_list) &&                  \
    !defined(__need_va_arg) && !defined(__need___va_copy) &&                   \
    !defined(__need_va_copy)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#define __need___va_list
#define __need_va_list
#define __need_va_arg
#define __need___va_copy
/* GCC always defines __va_copy, but does not define va_copy unless in c99 mode
 * or -ansi is not specified, since it was not part of C90.
 */
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L) ||                        \
    !defined(__STRICT_ANSI__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 45 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#define __need_va_copy
#endif
# 47 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 47 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#endif
# 49 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need___va_list
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stdarg___gnuc_va_list.h expanded by -frewrite-includes */
#include <__stdarg___gnuc_va_list.h>
#else /* __stdarg___gnuc_va_list.h expanded by -frewrite-includes */
# 51 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg___gnuc_va_list.h" 1 3
/*===---- __stdarg___gnuc_va_list.h - Definition of __gnuc_va_list ---------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __GNUC_VA_LIST
#define __GNUC_VA_LIST
typedef __builtin_va_list __gnuc_va_list;
#endif
# 14 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg___gnuc_va_list.h" 3
#endif /* __stdarg___gnuc_va_list.h expanded by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 2 3
#undef __need___va_list
#endif /* defined(__need___va_list) */
# 54 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need_va_list
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg_va_list.h>
#endif /* expanded by -frewrite-includes */
# 56 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 57 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need_va_list
#endif /* defined(__need_va_list) */
# 59 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need_va_arg
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg_va_arg.h>
#endif /* expanded by -frewrite-includes */
# 61 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 62 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need_va_arg
#endif /* defined(__need_va_arg) */
# 64 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need___va_copy
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg___va_copy.h>
#endif /* expanded by -frewrite-includes */
# 66 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 67 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need___va_copy
#endif /* defined(__need___va_copy) */
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need_va_copy
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg_va_copy.h>
#endif /* expanded by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 72 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need_va_copy
#endif /* defined(__need_va_copy) */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#endif /* __MVS__ */
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#endif /* stdarg.h expanded by -frewrite-includes */
# 41 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 2 3

/* typedef va_list only when required */
#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE >= 200809 || __XSI_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 44 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#ifdef __GNUC__
#ifndef _VA_LIST_DEFINED
typedef __gnuc_va_list va_list;
#define _VA_LIST_DEFINED
#endif
# 49 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#else /* !__GNUC__ */
# 50 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <stdarg.h>
#endif /* expanded by -frewrite-includes */
# 50 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 51 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 52 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif /* __POSIX_VISIBLE >= 200809 || __XSI_VISIBLE */
# 53 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

/*
 * <sys/reent.h> defines __FILE, _fpos_t.
 * They must be defined there because struct _reent needs them (and we don't
 * want reent.h to include this file.
 */

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* reent.h expanded by -frewrite-includes */
#include <sys/reent.h>
#else /* reent.h expanded by -frewrite-includes */
# 60 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 1 3
/* This header file provides the reentrancy.  */

/* WARNING: All identifiers here must begin with an underscore.  This file is
   included by stdio.h and others and we therefore must only use identifiers
   in the namespace allotted to us.  */

#ifndef _SYS_REENT_H_
#ifdef __cplusplus
extern "C" {
#endif
# 11 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define _SYS_REENT_H_

#if 0 /* expanded by -frewrite-includes */
#include <_ansi.h>
#endif /* expanded by -frewrite-includes */
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 14 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stddef.h expanded by -frewrite-includes */
#include <stddef.h>
#else /* stddef.h expanded by -frewrite-includes */
# 14 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 1 3
/*===---- stddef.h - Basic type definitions --------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stddef.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stddef.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#undef __need_size_t
#undef __need_rsize_t
#undef __need_wchar_t
#undef __need_NULL
#undef __need_nullptr_t
#undef __need_unreachable
#undef __need_max_align_t
#undef __need_offsetof
#undef __need_wint_t
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stddef.h>
#endif /* expanded by -frewrite-includes */
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#else
# 37 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__need_ptrdiff_t) && !defined(__need_size_t) &&                   \
    !defined(__need_rsize_t) && !defined(__need_wchar_t) &&                    \
    !defined(__need_NULL) && !defined(__need_nullptr_t) &&                     \
    !defined(__need_unreachable) && !defined(__need_max_align_t) &&            \
    !defined(__need_offsetof) && !defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 43 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_ptrdiff_t
#define __need_size_t
/* ISO9899:2011 7.20 (C11 Annex K): Define rsize_t if __STDC_WANT_LIB_EXT1__ is
 * enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_rsize_t
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_wchar_t
#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDDEF_H) || __has_feature(modules)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
/*
 * __stddef_null.h is special when building without modules: if __need_NULL is
 * set, then it will unconditionally redefine NULL. To avoid stepping on client
 * definitions of NULL, __need_NULL should only be set the first time this
 * header is included, that is when __STDDEF_H is not defined. However, when
 * building with modules, this header is a textual header and needs to
 * unconditionally include __stdef_null.h to support multiple submodules
 * exporting _Builtin_stddef.null. Take module SM with submodules A and B, whose
 * headers both include stddef.h When SM.A builds, __STDDEF_H will be defined.
 * When SM.B builds, the definition from SM.A will leak when building without
 * local submodule visibility. stddef.h wouldn't include __stddef_null.h, and
 * SM.B wouldn't import _Builtin_stddef.null, and SM.B's `export *` wouldn't
 * export NULL as expected. When building with modules, always include
 * __stddef_null.h so that everything works as expected.
 */
#define __need_NULL
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) ||              \
    defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_nullptr_t
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_unreachable
#endif
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 78 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_max_align_t
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_offsetof
/* wint_t is provided by <wchar.h> and not <stddef.h>. It's here
 * for compatibility, but must be explicitly requested. Therefore
 * __need_wint_t is intentionally not defined here. */
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 85 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_ptrdiff_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
#include <__stddef_ptrdiff_t.h>
#else /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 1 3
/*===---- __stddef_ptrdiff_t.h - Definition of ptrdiff_t -------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_PTRDIFF_T) ||                                                    \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 3
#define _PTRDIFF_T

typedef __PTRDIFF_TYPE__ ptrdiff_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_ptrdiff_t.h" 3
#endif /* __stddef_ptrdiff_t.h expanded by -frewrite-includes */
# 89 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_ptrdiff_t
#endif /* defined(__need_ptrdiff_t) */
# 91 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_size_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_size_t.h expanded by -frewrite-includes */
#include <__stddef_size_t.h>
#else /* __stddef_size_t.h expanded by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 1 3
/*===---- __stddef_size_t.h - Definition of size_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_SIZE_T) ||                                                       \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#define _SIZE_T

typedef __SIZE_TYPE__ size_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#endif /* __stddef_size_t.h expanded by -frewrite-includes */
# 94 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_size_t
#endif /*defined(__need_size_t) */
# 96 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_rsize_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_rsize_t.h>
#endif /* expanded by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_rsize_t
#endif /* defined(__need_rsize_t) */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wchar_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_wchar_t.h expanded by -frewrite-includes */
#include <__stddef_wchar_t.h>
#else /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 1 3
/*===---- __stddef_wchar.h - Definition of wchar_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#if 0 /* disabled by -frewrite-includes */
#if !defined(__cplusplus) || (defined(_MSC_VER) && !_NATIVE_WCHAR_T_DEFINED)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 11 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_WCHAR_T) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#define _WCHAR_T

#ifdef _MSC_EXTENSIONS
#define _WCHAR_T_DEFINED
#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

typedef __WCHAR_TYPE__ wchar_t;

#endif
# 27 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3

#endif
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wchar_t.h" 3
#endif /* __stddef_wchar_t.h expanded by -frewrite-includes */
# 104 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_wchar_t
#endif /* defined(__need_wchar_t) */
# 106 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_NULL)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_null.h>
#endif /* expanded by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 109 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_NULL
#endif /* defined(__need_NULL) */
# 111 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_nullptr_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_nullptr_t.h>
#endif /* expanded by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 114 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_nullptr_t
#endif /* defined(__need_nullptr_t) */
# 116 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_unreachable.h>
#endif /* expanded by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 119 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_unreachable
#endif /* defined(__need_unreachable) */
# 121 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_max_align_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_max_align_t.h>
#endif /* expanded by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 124 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_max_align_t
#endif /* defined(__need_max_align_t) */
# 126 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_offsetof)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_offsetof.h expanded by -frewrite-includes */
#include <__stddef_offsetof.h>
#else /* __stddef_offsetof.h expanded by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 1 3
/*===---- __stddef_offsetof.h - Definition of offsetof ---------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(offsetof) ||                                                      \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 3
#define offsetof(t, d) __builtin_offsetof(t, d)
#endif
# 18 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_offsetof.h" 3
#endif /* __stddef_offsetof.h expanded by -frewrite-includes */
# 129 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_offsetof
#endif /* defined(__need_offsetof) */
# 131 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

/* Some C libraries expect to see a wint_t here. Others (notably MinGW) will use
__WINT_TYPE__ directly; accommodate both by requiring __need_wint_t */
#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wint_t.h>
#endif /* expanded by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 136 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wint_t
#endif /* __need_wint_t */
# 138 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#endif /* __MVS__ */
# 140 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif /* stddef.h expanded by -frewrite-includes */
# 15 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 2 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/cdefs.h>
#endif /* expanded by -frewrite-includes */
# 15 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 16 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _types.h expanded by -frewrite-includes */
#include <sys/_types.h>
#else /* _types.h expanded by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 1 3
/* ANSI C namespace clean utility typedefs */

/* This file defines various typedefs needed by the system calls that support
   the C library.  Basically, they're just the POSIX versions with an '_'
   prepended.  Targets shall use <machine/_types.h> to define their own
   internal types if desired.

   There are three define patterns used for type definitions.  Lets assume
   xyz_t is a user type.

   The internal type definition uses __machine_xyz_t_defined.  It is defined by
   <machine/_types.h> to disable a default definition in <sys/_types.h>. It
   must not be used in other files.

   User type definitions are guarded by __xyz_t_defined in glibc and
   _XYZ_T_DECLARED in BSD compatible systems.
*/

#ifndef	_SYS__TYPES_H
#define _SYS__TYPES_H

#define __need_size_t
#define __need_wint_t
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stddef.h expanded by -frewrite-includes */
#include <stddef.h>
#else /* stddef.h expanded by -frewrite-includes */
# 24 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 1 3
/*===---- stddef.h - Basic type definitions --------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stddef.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stddef.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#undef __need_size_t
#undef __need_rsize_t
#undef __need_wchar_t
#undef __need_NULL
#undef __need_nullptr_t
#undef __need_unreachable
#undef __need_max_align_t
#undef __need_offsetof
#undef __need_wint_t
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 33 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stddef.h>
#endif /* expanded by -frewrite-includes */
# 34 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#else
# 37 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(__need_ptrdiff_t) && !defined(__need_size_t) &&                   \
    !defined(__need_rsize_t) && !defined(__need_wchar_t) &&                    \
    !defined(__need_NULL) && !defined(__need_nullptr_t) &&                     \
    !defined(__need_unreachable) && !defined(__need_max_align_t) &&            \
    !defined(__need_offsetof) && !defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 43 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_ptrdiff_t
#define __need_size_t
/* ISO9899:2011 7.20 (C11 Annex K): Define rsize_t if __STDC_WANT_LIB_EXT1__ is
 * enabled. */
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_WANT_LIB_EXT1__) && __STDC_WANT_LIB_EXT1__ >= 1
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_rsize_t
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_wchar_t
#if 0 /* disabled by -frewrite-includes */
#if !defined(__STDDEF_H) || __has_feature(modules)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
/*
 * __stddef_null.h is special when building without modules: if __need_NULL is
 * set, then it will unconditionally redefine NULL. To avoid stepping on client
 * definitions of NULL, __need_NULL should only be set the first time this
 * header is included, that is when __STDDEF_H is not defined. However, when
 * building with modules, this header is a textual header and needs to
 * unconditionally include __stdef_null.h to support multiple submodules
 * exporting _Builtin_stddef.null. Take module SM with submodules A and B, whose
 * headers both include stddef.h When SM.A builds, __STDDEF_H will be defined.
 * When SM.B builds, the definition from SM.A will leak when building without
 * local submodule visibility. stddef.h wouldn't include __stddef_null.h, and
 * SM.B wouldn't import _Builtin_stddef.null, and SM.B's `export *` wouldn't
 * export NULL as expected. When building with modules, always include
 * __stddef_null.h so that everything works as expected.
 */
#define __need_NULL
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) ||              \
    defined(__cplusplus)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_nullptr_t
#endif
# 73 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_unreachable
#endif
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 78 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_max_align_t
#endif
# 80 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#define __need_offsetof
/* wint_t is provided by <wchar.h> and not <stddef.h>. It's here
 * for compatibility, but must be explicitly requested. Therefore
 * __need_wint_t is intentionally not defined here. */
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 85 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif
# 86 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_ptrdiff_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_ptrdiff_t.h>
#endif /* expanded by -frewrite-includes */
# 88 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 89 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_ptrdiff_t
#endif /* defined(__need_ptrdiff_t) */
# 91 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_size_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_size_t.h expanded by -frewrite-includes */
#include <__stddef_size_t.h>
#else /* __stddef_size_t.h expanded by -frewrite-includes */
# 93 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 1 3
/*===---- __stddef_size_t.h - Definition of size_t -------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * When -fbuiltin-headers-in-system-modules is set this is a non-modular header
 * and needs to behave as if it was textual.
 */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_SIZE_T) ||                                                       \
    (__has_feature(modules) && !__building_module(_Builtin_stddef))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#define _SIZE_T

typedef __SIZE_TYPE__ size_t;

#endif
# 21 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_size_t.h" 3
#endif /* __stddef_size_t.h expanded by -frewrite-includes */
# 94 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_size_t
#endif /*defined(__need_size_t) */
# 96 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_rsize_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_rsize_t.h>
#endif /* expanded by -frewrite-includes */
# 98 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 99 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_rsize_t
#endif /* defined(__need_rsize_t) */
# 101 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wchar_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_wchar_t.h>
#endif /* expanded by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 104 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_wchar_t
#endif /* defined(__need_wchar_t) */
# 106 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_NULL)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_null.h>
#endif /* expanded by -frewrite-includes */
# 108 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 109 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_NULL
#endif /* defined(__need_NULL) */
# 111 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_nullptr_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_nullptr_t.h>
#endif /* expanded by -frewrite-includes */
# 113 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 114 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_nullptr_t
#endif /* defined(__need_nullptr_t) */
# 116 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_unreachable)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_unreachable.h>
#endif /* expanded by -frewrite-includes */
# 118 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 119 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_unreachable
#endif /* defined(__need_unreachable) */
# 121 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_max_align_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_max_align_t.h>
#endif /* expanded by -frewrite-includes */
# 123 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 124 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_max_align_t
#endif /* defined(__need_max_align_t) */
# 126 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__need_offsetof)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <__stddef_offsetof.h>
#endif /* expanded by -frewrite-includes */
# 128 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 129 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#undef __need_offsetof
#endif /* defined(__need_offsetof) */
# 131 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

/* Some C libraries expect to see a wint_t here. Others (notably MinGW) will use
__WINT_TYPE__ directly; accommodate both by requiring __need_wint_t */
#if 0 /* disabled by -frewrite-includes */
#if defined(__need_wint_t)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stddef_wint_t.h expanded by -frewrite-includes */
#include <__stddef_wint_t.h>
#else /* __stddef_wint_t.h expanded by -frewrite-includes */
# 135 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wint_t.h" 1 3
/*===---- __stddef_wint.h - Definition of wint_t ---------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef _WINT_T
#define _WINT_T

typedef __WINT_TYPE__ wint_t;

#endif
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stddef_wint_t.h" 3
#endif /* __stddef_wint_t.h expanded by -frewrite-includes */
# 136 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 2 3
#undef __need_wint_t
#endif /* __need_wint_t */
# 138 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3

#endif /* __MVS__ */
# 140 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stddef.h" 3
#endif /* stddef.h expanded by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 2 3
#if 0 /* expanded by -frewrite-includes */
#include <newlib.h>
#endif /* expanded by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/config.h>
#endif /* expanded by -frewrite-includes */
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
# 27 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* _types.h expanded by -frewrite-includes */
#include <machine/_types.h>
#else /* _types.h expanded by -frewrite-includes */
# 27 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_types.h" 1 3
/*
 *  $Id$
 */

#ifndef _MACHINE__TYPES_H
#define _MACHINE__TYPES_H
#if 0 /* expanded by -frewrite-includes */
#include <machine/_default_types.h>
#endif /* expanded by -frewrite-includes */
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_types.h" 3
# 8 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_types.h" 3
#endif
# 9 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/machine/_types.h" 3
#endif /* _types.h expanded by -frewrite-includes */
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 2 3

#ifndef __machine_blkcnt_t_defined
typedef long __blkcnt_t;
#endif
# 32 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_blksize_t_defined
typedef long __blksize_t;
#endif
# 36 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_fsblkcnt_t_defined
typedef __uint64_t __fsblkcnt_t;
#endif
# 40 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_fsfilcnt_t_defined
typedef __uint32_t __fsfilcnt_t;
#endif
# 44 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_off_t_defined
typedef long _off_t;
#endif
# 48 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__XMK__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 50 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef signed char __pid_t;
#else
# 52 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef int __pid_t;
#endif
# 54 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_dev_t_defined
typedef short __dev_t;
#endif
# 58 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_uid_t_defined
typedef unsigned short __uid_t;
#endif
# 62 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#ifndef __machine_gid_t_defined
typedef unsigned short __gid_t;
#endif
# 65 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_id_t_defined
typedef __uint32_t __id_t;
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_ino_t_defined
#if 0 /* disabled by -frewrite-includes */
#if (defined(__i386__) && (defined(GO32) || defined(__MSDOS__))) || \
    defined(__sparc__) || defined(__SPU__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 73 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef unsigned long __ino_t;
#else
# 75 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef unsigned short __ino_t;
#endif
# 77 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 78 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_mode_t_defined
#if 0 /* disabled by -frewrite-includes */
#if defined(__i386__) && (defined(GO32) || defined(__MSDOS__))
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 81 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef int __mode_t;
#else
# 83 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__sparc__) && !defined(__sparc_v9__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 84 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#ifdef __svr4__
typedef unsigned long __mode_t;
#else
# 87 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef unsigned short __mode_t;
#endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#else
# 90 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef __uint32_t __mode_t;
#endif
# 92 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 93 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 94 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_off64_t_defined
__extension__ typedef long long _off64_t;
#endif
# 98 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#if 0 /* disabled by -frewrite-includes */
#if defined(__CYGWIN__) && !defined(__LP64__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 100 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef _off64_t __off_t;
#else
# 102 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef _off_t __off_t;
#endif
# 104 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

typedef _off64_t __loff_t;

#ifndef __machine_key_t_defined
typedef long __key_t;
#endif
# 110 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

/*
 * We need fpos_t for the following, but it doesn't have a leading "_",
 * so we use _fpos_t instead.
 */
#ifndef __machine_fpos_t_defined
typedef long _fpos_t;		/* XXX must match off_t in <sys/types.h> */
				/* (and must be `long' for now) */
#endif
# 119 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifdef __LARGE64_FILES
#ifndef __machine_fpos64_t_defined
typedef _off64_t _fpos64_t;
#endif
# 124 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 125 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

/* Defined by GCC provided <stddef.h> */
#undef __size_t

#ifndef __machine_size_t_defined
#ifdef __SIZE_TYPE__
typedef __SIZE_TYPE__ __size_t;
#else
# 133 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__INT_MAX__) && __INT_MAX__ == 2147483647
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 134 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef unsigned int __size_t;
#else
# 136 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef unsigned long __size_t;
#endif
# 138 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 139 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 140 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_ssize_t_defined
#ifdef __SIZE_TYPE__
/* If __SIZE_TYPE__ is defined (gcc) we define ssize_t based on size_t.
   We simply change "unsigned" to "signed" for this single definition
   to make sure ssize_t and size_t only differ by their signedness. */
#define unsigned signed
typedef __SIZE_TYPE__ _ssize_t;
#undef unsigned
#else
# 150 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#if 0 /* disabled by -frewrite-includes */
#if defined(__INT_MAX__) && __INT_MAX__ == 2147483647
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 151 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef int _ssize_t;
#else
# 153 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef long _ssize_t;
#endif
# 155 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 156 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif
# 157 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

typedef _ssize_t __ssize_t;

#ifndef __machine_mbstate_t_defined
/* Conversion state information.  */
typedef struct
{
  int __count;
  union
  {
    wint_t __wch;
    unsigned char __wchb[4];
  } __value;		/* Value so far.  */
} _mbstate_t;
#endif
# 172 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_iconv_t_defined
/* Iconv descriptor type */
typedef void *_iconv_t;
#endif
# 177 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_clock_t_defined
#define	_CLOCK_T_	unsigned long	/* clock() */
#endif
# 181 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

typedef	_CLOCK_T_	__clock_t;

#if 0 /* disabled by -frewrite-includes */
#if defined(_USE_LONG_TIME_T) || __LONG_MAX__ > 0x7fffffffL
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 185 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#define	_TIME_T_ long
#else
# 187 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#define	_TIME_T_ __int_least64_t
#endif
# 189 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef	_TIME_T_	__time_t;

#ifndef __machine_clockid_t_defined
#define	_CLOCKID_T_ 	unsigned long
#endif
# 194 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

typedef	_CLOCKID_T_	__clockid_t;

#ifndef __machine_daddr_t_defined
typedef	long		__daddr_t;
#endif
# 200 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#define	_TIMER_T_	unsigned long
typedef	_TIMER_T_	__timer_t;

#ifndef __machine_sa_family_t_defined
typedef	__uint8_t	__sa_family_t;
#endif
# 207 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#ifndef __machine_socklen_t_defined
typedef	__uint32_t	__socklen_t;
#endif
# 211 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

typedef	int		__nl_item;
typedef	unsigned short	__nlink_t;
typedef	long		__suseconds_t;	/* microseconds (signed) */
typedef	unsigned long	__useconds_t;	/* microseconds (unsigned) */

/*
 * Must be identical to the __GNUCLIKE_BUILTIN_VAALIST definition in
 * <sys/cdefs.h>.  The <sys/cdefs.h> must not be included here to avoid cyclic
 * header dependencies.
 */
#if 0 /* disabled by -frewrite-includes */
#if __GNUC_MINOR__ > 95 || __GNUC__ >= 3
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 223 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef	__builtin_va_list	__va_list;
#else
# 225 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
typedef	char *			__va_list;
#endif
# 227 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3

#endif	/* _SYS__TYPES_H */
# 229 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/_types.h" 3
#endif /* _types.h expanded by -frewrite-includes */
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 2 3

#define _NULL 0

#ifndef __Long
#if 0 /* disabled by -frewrite-includes */
#if __LONG_MAX__ == 2147483647L
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 22 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define __Long long
typedef unsigned __Long __ULong;
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif __INT_MAX__ == 2147483647
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define __Long int
typedef unsigned __Long __ULong;
#endif
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#endif
# 29 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined( __Long)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/types.h>
#endif /* expanded by -frewrite-includes */
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 32 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#endif
# 33 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#ifndef __machine_flock_t_defined
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* lock.h expanded by -frewrite-includes */
#include <sys/lock.h>
#else /* lock.h expanded by -frewrite-includes */
# 35 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 1 3
#ifndef __SYS_LOCK_H__
#define __SYS_LOCK_H__

/* dummy lock routines for single-threaded aps */

#if 0 /* expanded by -frewrite-includes */
#include <newlib.h>
#endif /* expanded by -frewrite-includes */
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <_ansi.h>
#endif /* expanded by -frewrite-includes */
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3
# 8 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(_RETARGETABLE_LOCKING)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3

typedef int _LOCK_T;
typedef int _LOCK_RECURSIVE_T;

#define __LOCK_INIT(class,lock) static int lock = 0;
#define __LOCK_INIT_RECURSIVE(class,lock) static int lock = 0;
#define __lock_init(lock) ((void) 0)
#define __lock_init_recursive(lock) ((void) 0)
#define __lock_close(lock) ((void) 0)
#define __lock_close_recursive(lock) ((void) 0)
#define __lock_acquire(lock) ((void) 0)
#define __lock_acquire_recursive(lock) ((void) 0)
#define __lock_try_acquire(lock) ((void) 0)
#define __lock_try_acquire_recursive(lock) ((void) 0)
#define __lock_release(lock) ((void) 0)
#define __lock_release_recursive(lock) ((void) 0)

#else
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3

#ifdef __cplusplus
extern "C" {
#endif
# 32 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3

struct __lock;
typedef struct __lock * _LOCK_T;
#define _LOCK_RECURSIVE_T _LOCK_T

#define __LOCK_INIT(class,lock) extern struct __lock __lock_ ## lock; \
	class _LOCK_T lock = &__lock_ ## lock
#define __LOCK_INIT_RECURSIVE(class,lock) __LOCK_INIT(class,lock)

extern void __retarget_lock_init(_LOCK_T *lock);
#define __lock_init(lock) __retarget_lock_init(&lock)
extern void __retarget_lock_init_recursive(_LOCK_T *lock);
#define __lock_init_recursive(lock) __retarget_lock_init_recursive(&lock)
extern void __retarget_lock_close(_LOCK_T lock);
#define __lock_close(lock) __retarget_lock_close(lock)
extern void __retarget_lock_close_recursive(_LOCK_T lock);
#define __lock_close_recursive(lock) __retarget_lock_close_recursive(lock)
extern void __retarget_lock_acquire(_LOCK_T lock);
#define __lock_acquire(lock) __retarget_lock_acquire(lock)
extern void __retarget_lock_acquire_recursive(_LOCK_T lock);
#define __lock_acquire_recursive(lock) __retarget_lock_acquire_recursive(lock)
extern int __retarget_lock_try_acquire(_LOCK_T lock);
#define __lock_try_acquire(lock) __retarget_lock_try_acquire(lock)
extern int __retarget_lock_try_acquire_recursive(_LOCK_T lock);
#define __lock_try_acquire_recursive(lock) \
  __retarget_lock_try_acquire_recursive(lock)
extern void __retarget_lock_release(_LOCK_T lock);
#define __lock_release(lock) __retarget_lock_release(lock)
extern void __retarget_lock_release_recursive(_LOCK_T lock);
#define __lock_release_recursive(lock) __retarget_lock_release_recursive(lock)

#ifdef __cplusplus
}
#endif
# 66 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3

#endif /* !defined(_RETARGETABLE_LOCKING) */
# 68 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3

#endif /* __SYS_LOCK_H__ */
# 70 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/lock.h" 3
#endif /* lock.h expanded by -frewrite-includes */
# 36 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 2 3
typedef _LOCK_RECURSIVE_T _flock_t;
#endif
# 38 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#ifndef __Long
#define __Long __int32_t
typedef __uint32_t __ULong;
#endif
# 43 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

struct _reent;

struct __locale_t;

/*
 * If _REENT_SMALL is defined, we make struct _reent as small as possible,
 * by having nearly everything possible allocated at first use.
 */

struct _Bigint
{
  struct _Bigint *_next;
  int _k, _maxwds, _sign, _wds;
  __ULong _x[1];
};

/* needed by reentrant structure */
struct __tm
{
  int   __tm_sec;
  int   __tm_min;
  int   __tm_hour;
  int   __tm_mday;
  int   __tm_mon;
  int   __tm_year;
  int   __tm_wday;
  int   __tm_yday;
  int   __tm_isdst;
};

/*
 * atexit() support.
 */

#define	_ATEXIT_SIZE 32	/* must be at least 32 to guarantee ANSI conformance */

struct _on_exit_args {
	void *  _fnargs[_ATEXIT_SIZE];	        /* user fn args */
	void *	_dso_handle[_ATEXIT_SIZE];
	/* Bitmask is set if user function takes arguments.  */
	__ULong _fntypes;           	        /* type of exit routine -
				   Must have at least _ATEXIT_SIZE bits */
	/* Bitmask is set if function was registered via __cxa_atexit.  */
	__ULong _is_cxa;
};

#ifdef _REENT_SMALL
struct _atexit {
	struct	_atexit *_next;			/* next in list */
	int	_ind;				/* next index in this table */
	void	(*_fns[_ATEXIT_SIZE])(void);	/* the table itself */
        struct _on_exit_args * _on_exit_args_ptr;
};
# define _ATEXIT_INIT {_NULL, 0, {_NULL}, _NULL}
#else
# 99 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
struct _atexit {
	struct	_atexit *_next;			/* next in list */
	int	_ind;				/* next index in this table */
	/* Some entries may already have been called, and will be NULL.  */
	void	(*_fns[_ATEXIT_SIZE])(void);	/* the table itself */
        struct _on_exit_args _on_exit_args;
};
# define _ATEXIT_INIT {_NULL, 0, {_NULL}, {{_NULL}, {_NULL}, 0, 0}}
#endif
# 108 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

/*
 * Stdio buffers.
 *
 * This and __FILE are defined here because we need them for struct _reent,
 * but we don't want stdio.h included when stdlib.h is.
 */

struct __sbuf {
	unsigned char *_base;
	int	_size;
};

/*
 * Stdio state variables.
 *
 * The following always hold:
 *
 *	if (_flags&(__SLBF|__SWR)) == (__SLBF|__SWR),
 *		_lbfsize is -_bf._size, else _lbfsize is 0
 *	if _flags&__SRD, _w is 0
 *	if _flags&__SWR, _r is 0
 *
 * This ensures that the getc and putc macros (or inline functions) never
 * try to write or read from a file that is in `read' or `write' mode.
 * (Moreover, they can, and do, automatically switch from read mode to
 * write mode, and back, on "r+" and "w+" files.)
 *
 * _lbfsize is used only to make the inline line-buffered output stream
 * code as compact as possible.
 *
 * _ub, _up, and _ur are used when ungetc() pushes back more characters
 * than fit in the current _bf, or when ungetc() pushes back a character
 * that does not match the previous one in _bf.  When this happens,
 * _ub._base becomes non-nil (i.e., a stream has ungetc() data iff
 * _ub._base!=NULL) and _up and _ur save the current values of _p and _r.
 */

#define _REENT_SMALL_CHECK_INIT(ptr) /* nothing */

/* Cygwin must use __sFILE64 for backward compatibility, even though
   it's not defining __LARGE64_FILES anymore.  To make sure that __sFILE
   is never defined, disable it here explicitely. */
#ifndef __CYGWIN__

struct __sFILE {
  unsigned char *_p;	/* current position in (some) buffer */
  int	_r;		/* read space left for getc() */
  int	_w;		/* write space left for putc() */
  short	_flags;		/* flags, below; this FILE is free if 0 */
  short	_file;		/* fileno, if Unix descriptor, else -1 */
  struct __sbuf _bf;	/* the buffer (at least 1 byte, if !NULL) */
  int	_lbfsize;	/* 0 or -_bf._size, for inline putc */

#ifdef _REENT_SMALL
  struct _reent *_data;
#endif
# 165 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

  /* operations */
  void *	_cookie;	/* cookie passed to io functions */

  _READ_WRITE_RETURN_TYPE (*_read) (struct _reent *, void *,
					   char *, _READ_WRITE_BUFSIZE_TYPE);
  _READ_WRITE_RETURN_TYPE (*_write) (struct _reent *, void *,
					    const char *,
					    _READ_WRITE_BUFSIZE_TYPE);
  _fpos_t (*_seek) (struct _reent *, void *, _fpos_t, int);
  int (*_close) (struct _reent *, void *);

  /* separate buffer for long sequences of ungetc() */
  struct __sbuf _ub;	/* ungetc buffer */
  unsigned char *_up;	/* saved _p when _p is doing ungetc data */
  int	_ur;		/* saved _r when _r is counting ungetc data */

  /* tricks to meet minimum requirements even when malloc() fails */
  unsigned char _ubuf[3];	/* guarantee an ungetc() buffer */
  unsigned char _nbuf[1];	/* guarantee a getc() buffer */

  /* separate buffer for fgetline() when line crosses buffer boundary */
  struct __sbuf _lb;	/* buffer for fgetline() */

  /* Unix stdio files get aligned to block boundaries on fseek() */
  int	_blksize;	/* stat.st_blksize (may be != _bf._size) */
  _off_t _offset;	/* current lseek offset */

#ifndef _REENT_SMALL
  struct _reent *_data;	/* Here for binary compatibility? Remove? */
#endif
# 196 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#ifndef __SINGLE_THREAD__
  _flock_t _lock;	/* for thread-safety locking */
#endif
# 200 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
  _mbstate_t _mbstate;	/* for wide char stdio functions. */
  int   _flags2;        /* for future use */
};

#endif /* !__CYGWIN__ */
# 205 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#ifdef __CUSTOM_FILE_IO__

/* Get custom _FILE definition.  */
#if 0 /* expanded by -frewrite-includes */
#include <sys/custom_file.h>
#endif /* expanded by -frewrite-includes */
# 209 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 210 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#else /* !__CUSTOM_FILE_IO__ */
# 212 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
/* Cygwin must use __sFILE64 for backward compatibility, even though
   it's not defining __LARGE64_FILES anymore.  It also has to make
   sure the name is the same to satisfy C++ name mangling.  Overloading
   _fpos64_t just fixes a build problem.  The _seek64 function is
   actually never used without __LARGE64_FILES being defined. */
#if 0 /* disabled by -frewrite-includes */
#if defined (__LARGE64_FILES) || defined (__CYGWIN__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 218 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#ifdef __CYGWIN__
#define _fpos64_t _fpos_t
#endif
# 221 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

struct __sFILE64 {
  unsigned char *_p;	/* current position in (some) buffer */
  int	_r;		/* read space left for getc() */
  int	_w;		/* write space left for putc() */
  short	_flags;		/* flags, below; this FILE is free if 0 */
  short	_file;		/* fileno, if Unix descriptor, else -1 */
  struct __sbuf _bf;	/* the buffer (at least 1 byte, if !NULL) */
  int	_lbfsize;	/* 0 or -_bf._size, for inline putc */

  struct _reent *_data;

  /* operations */
  void *	_cookie;	/* cookie passed to io functions */

  _READ_WRITE_RETURN_TYPE (*_read) (struct _reent *, void *,
					   char *, _READ_WRITE_BUFSIZE_TYPE);
  _READ_WRITE_RETURN_TYPE (*_write) (struct _reent *, void *,
					    const char *,
					    _READ_WRITE_BUFSIZE_TYPE);
  _fpos_t (*_seek) (struct _reent *, void *, _fpos_t, int);
  int (*_close) (struct _reent *, void *);

  /* separate buffer for long sequences of ungetc() */
  struct __sbuf _ub;	/* ungetc buffer */
  unsigned char *_up;	/* saved _p when _p is doing ungetc data */
  int	_ur;		/* saved _r when _r is counting ungetc data */

  /* tricks to meet minimum requirements even when malloc() fails */
  unsigned char _ubuf[3];	/* guarantee an ungetc() buffer */
  unsigned char _nbuf[1];	/* guarantee a getc() buffer */

  /* separate buffer for fgetline() when line crosses buffer boundary */
  struct __sbuf _lb;	/* buffer for fgetline() */

  /* Unix stdio files get aligned to block boundaries on fseek() */
  int	_blksize;	/* stat.st_blksize (may be != _bf._size) */
  int   _flags2;        /* for future use */

  _off64_t _offset;     /* current lseek offset */
  _fpos64_t (*_seek64) (struct _reent *, void *, _fpos64_t, int);

#ifndef __SINGLE_THREAD__
  _flock_t _lock;	/* for thread-safety locking */
#endif
# 266 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
  _mbstate_t _mbstate;	/* for wide char stdio functions. */
};
typedef struct __sFILE64 __FILE;
#else
# 270 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
typedef struct __sFILE   __FILE;
#endif /* __LARGE64_FILES */
# 272 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#endif /* !__CUSTOM_FILE_IO__ */
# 273 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

extern __FILE __sf[3];

struct _glue
{
  struct _glue *_next;
  int _niobs;
  __FILE *_iobs;
};

extern struct _glue __sglue;

/*
 * rand48 family support
 *
 * Copyright (c) 1993 Martin Birgmeier
 * All rights reserved.
 *
 * You may redistribute unmodified or modified versions of this source
 * code provided that the above copyright notice and this and the
 * following conditions are retained.
 *
 * This software is provided ``as is'', and comes with no warranties
 * of any kind. I shall in no event be liable for anything that happens
 * to anyone/anything when using this software.
 */
#define        _RAND48_SEED_0  (0x330e)
#define        _RAND48_SEED_1  (0xabcd)
#define        _RAND48_SEED_2  (0x1234)
#define        _RAND48_MULT_0  (0xe66d)
#define        _RAND48_MULT_1  (0xdeec)
#define        _RAND48_MULT_2  (0x0005)
#define        _RAND48_ADD     (0x000b)
struct _rand48 {
  unsigned short _seed[3];
  unsigned short _mult[3];
  unsigned short _add;
#ifdef _REENT_SMALL
  /* Put this in here as well, for good luck.  */
  __extension__ unsigned long long _rand_next;
#endif
# 314 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
};

/* How big the some arrays are.  */
#define _REENT_EMERGENCY_SIZE 25
#define _REENT_ASCTIME_SIZE 26
#define _REENT_SIGNAL_SIZE 24

#ifndef _REENT_THREAD_LOCAL

#ifdef _REENT_BACKWARD_BINARY_COMPAT
#define _REENT_INIT_RESERVED_0 0,
#define _REENT_INIT_RESERVED_1 0,
#define _REENT_INIT_RESERVED_2 0,
#define _REENT_INIT_RESERVED_6_7 _NULL, _ATEXIT_INIT,
#define _REENT_INIT_RESERVED_8 {_NULL, 0, _NULL},
#else
# 330 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define _REENT_INIT_RESERVED_0 /* Nothing to initialize */
#define _REENT_INIT_RESERVED_1 /* Nothing to initialize */
#define _REENT_INIT_RESERVED_2 /* Nothing to initialize */
#define _REENT_INIT_RESERVED_6_7 /* Nothing to initialize */
#define _REENT_INIT_RESERVED_8 /* Nothing to initialize */
#endif
# 336 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

/*
 * struct _reent
 *
 * This structure contains the thread-local objects needed by the library.
 * It's raison d'etre is to facilitate threads by making all library routines
 * reentrant.  The exit handler support and FILE maintenance use dedicated
 * global objects which are not included in this structure.
 */

#ifdef _REENT_SMALL

struct _mprec
{
  /* used by mprec routines */
  struct _Bigint *_result;
  int _result_k;
  struct _Bigint *_p5s;
  struct _Bigint **_freelist;
};


struct _misc_reent
{
  /* miscellaneous reentrant data */
  char *_strtok_last;
  _mbstate_t _mblen_state;
  _mbstate_t _wctomb_state;
  _mbstate_t _mbtowc_state;
  char _l64a_buf[8];
  int _getdate_err;
  _mbstate_t _mbrlen_state;
  _mbstate_t _mbrtowc_state;
  _mbstate_t _mbsrtowcs_state;
  _mbstate_t _wcrtomb_state;
  _mbstate_t _wcsrtombs_state;
};

/* This version of _reent is laid out with "int"s in pairs, to help
 * ports with 16-bit int's but 32-bit pointers, align nicely.  */
struct _reent
{
  /* As an exception to the above put _errno first for binary
     compatibility with non _REENT_SMALL targets.  */
  int _errno;			/* local copy of errno */

  /* FILE is a big struct and may change over time.  To try to achieve binary
     compatibility with future versions, put stdin,stdout,stderr here.
     These are pointers into member __sf defined below.  */
  __FILE *_stdin, *_stdout, *_stderr;	/* XXX */

  int  _inc;			/* used by tmpnam */

  char *_emergency;

#ifdef _REENT_BACKWARD_BINARY_COMPAT
  int _reserved_0;
  int _reserved_1;
#endif
# 395 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
  struct __locale_t *_locale;/* per-thread locale */

  struct _mprec *_mp;

  void (*__cleanup) (struct _reent *);

  int _gamma_signgam;

  /* used by some fp conversion routines */
  int _cvtlen;			/* should be size_t */
  char *_cvtbuf;

  struct _rand48 *_r48;
  struct __tm *_localtime_buf;
  char *_asctime_buf;

  /* signal info */
  void (** _sig_func)(int);

#ifdef _REENT_BACKWARD_BINARY_COMPAT
  struct _atexit *_reserved_6;
  struct _atexit _reserved_7;
  struct _glue _reserved_8;
#endif
# 419 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

  __FILE *__sf;			        /* file descriptors */
  struct _misc_reent *_misc;            /* strtok, multibyte states */
  char *_signal_buf;                    /* strsignal */
};

# define _REENT_INIT(var) \
  { 0, \
    &__sf[0], \
    &__sf[1], \
    &__sf[2], \
    0,   \
    _NULL, \
    _REENT_INIT_RESERVED_0 \
    _REENT_INIT_RESERVED_1 \
    _NULL, \
    _NULL, \
    _NULL, \
    0, \
    0, \
    _NULL, \
    _NULL, \
    _NULL, \
    _NULL, \
    _NULL, \
    _REENT_INIT_RESERVED_6_7 \
    _REENT_INIT_RESERVED_8 \
    _NULL, \
    _NULL, \
    _NULL \
  }

#define _REENT_INIT_PTR_ZEROED(var) \
  { (var)->_stdin = &__sf[0]; \
    (var)->_stdout = &__sf[1]; \
    (var)->_stderr = &__sf[2]; \
  }

/* Specify how to handle reent_check malloc failures. */
#ifdef _REENT_CHECK_VERIFY
#if 0 /* expanded by -frewrite-includes */
#include <assert.h>
#endif /* expanded by -frewrite-includes */
# 459 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# 460 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define __reent_assert(x) ((x) ? (void)0 : __assert_func(__FILE__, __LINE__, (char *)0, "REENT malloc succeeded"))
#else
# 462 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define __reent_assert(x) ((void)0)
#endif
# 464 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#ifdef __CUSTOM_FILE_IO__
#error Custom FILE I/O and _REENT_SMALL not currently supported.
#endif
# 468 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

/* Generic _REENT check macro.  */
#define _REENT_CHECK(var, what, type, size, init) do { \
  struct _reent *_r = (var); \
  if (_r->what == NULL) { \
    _r->what = (type)malloc(size); \
    __reent_assert(_r->what); \
    init; \
  } \
} while (0)

#define _REENT_CHECK_TM(var) \
  _REENT_CHECK(var, _localtime_buf, struct __tm *, sizeof *((var)->_localtime_buf), \
    /* nothing */)

#define _REENT_CHECK_ASCTIME_BUF(var) \
  _REENT_CHECK(var, _asctime_buf, char *, _REENT_ASCTIME_SIZE, \
    memset((var)->_asctime_buf, 0, _REENT_ASCTIME_SIZE))

/* Handle the dynamically allocated rand48 structure. */
#define _REENT_INIT_RAND48(var) do { \
  struct _reent *_r = (var); \
  _r->_r48->_seed[0] = _RAND48_SEED_0; \
  _r->_r48->_seed[1] = _RAND48_SEED_1; \
  _r->_r48->_seed[2] = _RAND48_SEED_2; \
  _r->_r48->_mult[0] = _RAND48_MULT_0; \
  _r->_r48->_mult[1] = _RAND48_MULT_1; \
  _r->_r48->_mult[2] = _RAND48_MULT_2; \
  _r->_r48->_add = _RAND48_ADD; \
  _r->_r48->_rand_next = 1; \
} while (0)
#define _REENT_CHECK_RAND48(var) \
  _REENT_CHECK(var, _r48, struct _rand48 *, sizeof *((var)->_r48), _REENT_INIT_RAND48((var)))

#define _REENT_INIT_MP(var) do { \
  struct _reent *_r = (var); \
  _r->_mp->_result_k = 0; \
  _r->_mp->_result = _r->_mp->_p5s = _NULL; \
  _r->_mp->_freelist = _NULL; \
} while (0)
#define _REENT_CHECK_MP(var) \
  _REENT_CHECK(var, _mp, struct _mprec *, sizeof *((var)->_mp), _REENT_INIT_MP(var))

#define _REENT_CHECK_EMERGENCY(var) \
  _REENT_CHECK(var, _emergency, char *, _REENT_EMERGENCY_SIZE, /* nothing */)

#define _REENT_INIT_MISC(var) do { \
  struct _reent *_r = (var); \
  _r->_misc->_strtok_last = _NULL; \
  _r->_misc->_mblen_state.__count = 0; \
  _r->_misc->_mblen_state.__value.__wch = 0; \
  _r->_misc->_wctomb_state.__count = 0; \
  _r->_misc->_wctomb_state.__value.__wch = 0; \
  _r->_misc->_mbtowc_state.__count = 0; \
  _r->_misc->_mbtowc_state.__value.__wch = 0; \
  _r->_misc->_mbrlen_state.__count = 0; \
  _r->_misc->_mbrlen_state.__value.__wch = 0; \
  _r->_misc->_mbrtowc_state.__count = 0; \
  _r->_misc->_mbrtowc_state.__value.__wch = 0; \
  _r->_misc->_mbsrtowcs_state.__count = 0; \
  _r->_misc->_mbsrtowcs_state.__value.__wch = 0; \
  _r->_misc->_wcrtomb_state.__count = 0; \
  _r->_misc->_wcrtomb_state.__value.__wch = 0; \
  _r->_misc->_wcsrtombs_state.__count = 0; \
  _r->_misc->_wcsrtombs_state.__value.__wch = 0; \
  _r->_misc->_l64a_buf[0] = '\0'; \
  _r->_misc->_getdate_err = 0; \
} while (0)
#define _REENT_CHECK_MISC(var) \
  _REENT_CHECK(var, _misc, struct _misc_reent *, sizeof *((var)->_misc), _REENT_INIT_MISC(var))

#define _REENT_CHECK_SIGNAL_BUF(var) \
  _REENT_CHECK(var, _signal_buf, char *, _REENT_SIGNAL_SIZE, /* nothing */)

#define _REENT_SIGNGAM(ptr)	((ptr)->_gamma_signgam)
#define _REENT_RAND_NEXT(ptr)	((ptr)->_r48->_rand_next)
#define _REENT_RAND48_SEED(ptr)	((ptr)->_r48->_seed)
#define _REENT_RAND48_MULT(ptr)	((ptr)->_r48->_mult)
#define _REENT_RAND48_ADD(ptr)	((ptr)->_r48->_add)
#define _REENT_MP_RESULT(ptr)	((ptr)->_mp->_result)
#define _REENT_MP_RESULT_K(ptr)	((ptr)->_mp->_result_k)
#define _REENT_MP_P5S(ptr)	((ptr)->_mp->_p5s)
#define _REENT_MP_FREELIST(ptr)	((ptr)->_mp->_freelist)
#define _REENT_ASCTIME_BUF(ptr)	((ptr)->_asctime_buf)
#define _REENT_TM(ptr)		((ptr)->_localtime_buf)
#define _REENT_STRTOK_LAST(ptr)	((ptr)->_misc->_strtok_last)
#define _REENT_MBLEN_STATE(ptr)	((ptr)->_misc->_mblen_state)
#define _REENT_MBTOWC_STATE(ptr)((ptr)->_misc->_mbtowc_state)
#define _REENT_WCTOMB_STATE(ptr)((ptr)->_misc->_wctomb_state)
#define _REENT_MBRLEN_STATE(ptr) ((ptr)->_misc->_mbrlen_state)
#define _REENT_MBRTOWC_STATE(ptr) ((ptr)->_misc->_mbrtowc_state)
#define _REENT_MBSRTOWCS_STATE(ptr) ((ptr)->_misc->_mbsrtowcs_state)
#define _REENT_WCRTOMB_STATE(ptr) ((ptr)->_misc->_wcrtomb_state)
#define _REENT_WCSRTOMBS_STATE(ptr) ((ptr)->_misc->_wcsrtombs_state)
#define _REENT_L64A_BUF(ptr)    ((ptr)->_misc->_l64a_buf)
#define _REENT_GETDATE_ERR_P(ptr) (&((ptr)->_misc->_getdate_err))
#define _REENT_SIGNAL_BUF(ptr)  ((ptr)->_signal_buf)

#else /* !_REENT_SMALL */
# 567 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

struct _reent
{
  int _errno;			/* local copy of errno */

  /* FILE is a big struct and may change over time.  To try to achieve binary
     compatibility with future versions, put stdin,stdout,stderr here.
     These are pointers into member __sf defined below.  */
  __FILE *_stdin, *_stdout, *_stderr;

  int  _inc;			/* used by tmpnam */
  char _emergency[_REENT_EMERGENCY_SIZE];

#ifdef _REENT_BACKWARD_BINARY_COMPAT
  int _reserved_1;
#endif
# 583 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
  struct __locale_t *_locale;/* per-thread locale */

#ifdef _REENT_BACKWARD_BINARY_COMPAT
  int _reserved_0;
#endif
# 588 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

  void (*__cleanup) (struct _reent *);

  /* used by mprec routines */
  struct _Bigint *_result;
  int _result_k;
  struct _Bigint *_p5s;
  struct _Bigint **_freelist;

  /* used by some fp conversion routines */
  int _cvtlen;			/* should be size_t */
  char *_cvtbuf;

  union
    {
      struct
        {
#ifdef _REENT_BACKWARD_BINARY_COMPAT
          unsigned int _reserved_2;
#endif
# 608 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
          char * _strtok_last;
          char _asctime_buf[_REENT_ASCTIME_SIZE];
          struct __tm _localtime_buf;
          int _gamma_signgam;
          __extension__ unsigned long long _rand_next;
          struct _rand48 _r48;
          _mbstate_t _mblen_state;
          _mbstate_t _mbtowc_state;
          _mbstate_t _wctomb_state;
          char _l64a_buf[8];
          char _signal_buf[_REENT_SIGNAL_SIZE];
          int _getdate_err;
          _mbstate_t _mbrlen_state;
          _mbstate_t _mbrtowc_state;
          _mbstate_t _mbsrtowcs_state;
          _mbstate_t _wcrtomb_state;
          _mbstate_t _wcsrtombs_state;
	  int _h_errno;
#ifdef __CYGWIN__
          _mbstate_t _c8rtomb_state;
          _mbstate_t _c16rtomb_state;
          _mbstate_t _c32rtomb_state;
          _mbstate_t _mbrtoc8_state;
          _mbstate_t _mbrtoc16_state;
          _mbstate_t _mbrtoc32_state;
#endif
# 634 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
        } _reent;
#ifdef _REENT_BACKWARD_BINARY_COMPAT
      struct
        {
          unsigned char * _reserved_3[30];
          unsigned int _reserved_4[30];
        } _reserved_5;
#endif
# 642 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
    } _new;

#ifdef _REENT_BACKWARD_BINARY_COMPAT
  struct _atexit *_reserved_6;
  struct _atexit _reserved_7;
#endif
# 648 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

  /* signal info */
  void (**_sig_func)(int);
};

#define _REENT_INIT(var) \
  { 0, \
    &__sf[0], \
    &__sf[1], \
    &__sf[2], \
    0, \
    "", \
    _REENT_INIT_RESERVED_1 \
    _NULL, \
    _REENT_INIT_RESERVED_0 \
    _NULL, \
    _NULL, \
    0, \
    _NULL, \
    _NULL, \
    0, \
    _NULL, \
    { \
      { \
        _REENT_INIT_RESERVED_2 \
        _NULL, \
        "", \
        {0, 0, 0, 0, 0, 0, 0, 0, 0}, \
        0, \
        1, \
        { \
          {_RAND48_SEED_0, _RAND48_SEED_1, _RAND48_SEED_2}, \
          {_RAND48_MULT_0, _RAND48_MULT_1, _RAND48_MULT_2}, \
          _RAND48_ADD \
        }, \
        {0, {0}}, \
        {0, {0}}, \
        {0, {0}}, \
        "", \
        "", \
        0, \
        {0, {0}}, \
        {0, {0}}, \
        {0, {0}}, \
        {0, {0}}, \
        {0, {0}} \
      } \
    }, \
    _REENT_INIT_RESERVED_6_7 \
    _NULL \
  }

#define _REENT_INIT_PTR_ZEROED(var) \
  { (var)->_stdin = &__sf[0]; \
    (var)->_stdout = &__sf[1]; \
    (var)->_stderr = &__sf[2]; \
    (var)->_new._reent._rand_next = 1; \
    (var)->_new._reent._r48._seed[0] = _RAND48_SEED_0; \
    (var)->_new._reent._r48._seed[1] = _RAND48_SEED_1; \
    (var)->_new._reent._r48._seed[2] = _RAND48_SEED_2; \
    (var)->_new._reent._r48._mult[0] = _RAND48_MULT_0; \
    (var)->_new._reent._r48._mult[1] = _RAND48_MULT_1; \
    (var)->_new._reent._r48._mult[2] = _RAND48_MULT_2; \
    (var)->_new._reent._r48._add = _RAND48_ADD; \
  }

#define _REENT_CHECK_RAND48(ptr)	/* nothing */
#define _REENT_CHECK_MP(ptr)		/* nothing */
#define _REENT_CHECK_TM(ptr)		/* nothing */
#define _REENT_CHECK_ASCTIME_BUF(ptr)	/* nothing */
#define _REENT_CHECK_EMERGENCY(ptr)	/* nothing */
#define _REENT_CHECK_MISC(ptr)	        /* nothing */
#define _REENT_CHECK_SIGNAL_BUF(ptr)	/* nothing */

#define _REENT_SIGNGAM(ptr)	((ptr)->_new._reent._gamma_signgam)
#define _REENT_RAND_NEXT(ptr)	((ptr)->_new._reent._rand_next)
#define _REENT_RAND48_SEED(ptr)	((ptr)->_new._reent._r48._seed)
#define _REENT_RAND48_MULT(ptr)	((ptr)->_new._reent._r48._mult)
#define _REENT_RAND48_ADD(ptr)	((ptr)->_new._reent._r48._add)
#define _REENT_MP_RESULT(ptr)	((ptr)->_result)
#define _REENT_MP_RESULT_K(ptr)	((ptr)->_result_k)
#define _REENT_MP_P5S(ptr)	((ptr)->_p5s)
#define _REENT_MP_FREELIST(ptr)	((ptr)->_freelist)
#define _REENT_ASCTIME_BUF(ptr)	((ptr)->_new._reent._asctime_buf)
#define _REENT_TM(ptr)		(&(ptr)->_new._reent._localtime_buf)
#define _REENT_STRTOK_LAST(ptr)	((ptr)->_new._reent._strtok_last)
#define _REENT_MBLEN_STATE(ptr)	((ptr)->_new._reent._mblen_state)
#define _REENT_MBTOWC_STATE(ptr)((ptr)->_new._reent._mbtowc_state)
#define _REENT_WCTOMB_STATE(ptr)((ptr)->_new._reent._wctomb_state)
#define _REENT_MBRLEN_STATE(ptr)((ptr)->_new._reent._mbrlen_state)
#define _REENT_MBRTOWC_STATE(ptr)((ptr)->_new._reent._mbrtowc_state)
#define _REENT_MBSRTOWCS_STATE(ptr)((ptr)->_new._reent._mbsrtowcs_state)
#define _REENT_WCRTOMB_STATE(ptr)((ptr)->_new._reent._wcrtomb_state)
#define _REENT_WCSRTOMBS_STATE(ptr)((ptr)->_new._reent._wcsrtombs_state)
#ifdef __CYGWIN__
#  define _REENT_C8RTOMB_STATE(ptr)((ptr)->_new._reent._c8rtomb_state)
#  define _REENT_C16RTOMB_STATE(ptr)((ptr)->_new._reent._c16rtomb_state)
#  define _REENT_C32RTOMB_STATE(ptr)((ptr)->_new._reent._c32rtomb_state)
#  define _REENT_MBRTOC8_STATE(ptr)((ptr)->_new._reent._mbrtoc8_state)
#  define _REENT_MBRTOC16_STATE(ptr)((ptr)->_new._reent._mbrtoc16_state)
#  define _REENT_MBRTOC32_STATE(ptr)((ptr)->_new._reent._mbrtoc32_state)
#endif
# 750 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#define _REENT_L64A_BUF(ptr)    ((ptr)->_new._reent._l64a_buf)
#define _REENT_SIGNAL_BUF(ptr)  ((ptr)->_new._reent._signal_buf)
#define _REENT_GETDATE_ERR_P(ptr) (&((ptr)->_new._reent._getdate_err))

#endif /* !_REENT_SMALL */
# 755 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#define _REENT_CLEANUP(_ptr)	((_ptr)->__cleanup)
#define _REENT_CVTBUF(_ptr)	((_ptr)->_cvtbuf)
#define _REENT_CVTLEN(_ptr)	((_ptr)->_cvtlen)
#define _REENT_EMERGENCY(_ptr)	((_ptr)->_emergency)
#define _REENT_ERRNO(_ptr)	((_ptr)->_errno)
#define _REENT_INC(_ptr)	((_ptr)->_inc)
#define _REENT_LOCALE(_ptr)	((_ptr)->_locale)
#define _REENT_SIG_FUNC(_ptr)	((_ptr)->_sig_func)
#define _REENT_STDIN(_ptr)	((_ptr)->_stdin)
#define _REENT_STDOUT(_ptr)	((_ptr)->_stdout)
#define _REENT_STDERR(_ptr)	((_ptr)->_stderr)

#define _REENT_INIT_PTR(var) \
  { memset((var), 0, sizeof(*(var))); \
    _REENT_INIT_PTR_ZEROED(var); \
  }

/*
 * All references to struct _reent are via this pointer.
 * Internally, newlib routines that need to reference it should use _REENT.
 */

#ifndef __ATTRIBUTE_IMPURE_PTR__
#define __ATTRIBUTE_IMPURE_PTR__
#endif
# 781 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

extern struct _reent *_impure_ptr __ATTRIBUTE_IMPURE_PTR__;

#ifndef __ATTRIBUTE_IMPURE_DATA__
#define __ATTRIBUTE_IMPURE_DATA__
#endif
# 787 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

extern struct _reent _impure_data __ATTRIBUTE_IMPURE_DATA__;

/* #define _REENT_ONLY define this to get only reentrant routines */

#if 0 /* disabled by -frewrite-includes */
#if defined(__DYNAMIC_REENT__) && !defined(__SINGLE_THREAD__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 793 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#ifndef __getreent
  struct _reent * __getreent (void);
#endif
# 796 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# define _REENT (__getreent())
#else /* __SINGLE_THREAD__ || !__DYNAMIC_REENT__ */
# 798 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
# define _REENT _impure_ptr
#endif /* __SINGLE_THREAD__ || !__DYNAMIC_REENT__ */
# 800 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#define _REENT_IS_NULL(_ptr) ((_ptr) == NULL)

#define _GLOBAL_REENT (&_impure_data)

#else /* _REENT_THREAD_LOCAL */
# 806 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

#define _REENT NULL
#define _GLOBAL_REENT NULL

/*
 * Since _REENT is defined as NULL, this macro ensures that calls to
 * CHECK_INIT() do not automatically fail.
 */
#define _REENT_IS_NULL(_ptr) 0

#define _REENT_CHECK_RAND48(ptr)	/* nothing */
#define _REENT_CHECK_MP(ptr)		/* nothing */
#define _REENT_CHECK_TM(ptr)		/* nothing */
#define _REENT_CHECK_ASCTIME_BUF(ptr)	/* nothing */
#define _REENT_CHECK_EMERGENCY(ptr)	/* nothing */
#define _REENT_CHECK_MISC(ptr)		/* nothing */
#define _REENT_CHECK_SIGNAL_BUF(ptr)	/* nothing */

extern _Thread_local char _tls_asctime_buf[_REENT_ASCTIME_SIZE];
#define _REENT_ASCTIME_BUF(_ptr) (_tls_asctime_buf)
extern _Thread_local char *_tls_cvtbuf;
#define _REENT_CVTBUF(_ptr) (_tls_cvtbuf)
extern _Thread_local int _tls_cvtlen;
#define _REENT_CVTLEN(_ptr) (_tls_cvtlen)
extern _Thread_local void (*_tls_cleanup)(struct _reent *);
#define _REENT_CLEANUP(_ptr) (_tls_cleanup)
extern _Thread_local char _tls_emergency[_REENT_EMERGENCY_SIZE];
#define _REENT_EMERGENCY(_ptr) (_tls_emergency)
extern _Thread_local int _tls_errno;
#define _REENT_ERRNO(_ptr) (_tls_errno)
extern _Thread_local int _tls_getdate_err;
#define _REENT_GETDATE_ERR_P(_ptr) (&_tls_getdate_err)
extern _Thread_local int _tls_inc;
#define _REENT_INC(_ptr) (_tls_inc)
extern _Thread_local char _tls_l64a_buf[8];
#define _REENT_L64A_BUF(_ptr) (_tls_l64a_buf)
extern _Thread_local struct __locale_t *_tls_locale;
#define _REENT_LOCALE(_ptr) (_tls_locale)
extern _Thread_local _mbstate_t _tls_mblen_state;
#define _REENT_MBLEN_STATE(_ptr) (_tls_mblen_state)
extern _Thread_local _mbstate_t _tls_mbrlen_state;
#define _REENT_MBRLEN_STATE(_ptr) (_tls_mbrlen_state)
extern _Thread_local _mbstate_t _tls_mbrtowc_state;
#define _REENT_MBRTOWC_STATE(_ptr) (_tls_mbrtowc_state)
extern _Thread_local _mbstate_t _tls_mbsrtowcs_state;
#define _REENT_MBSRTOWCS_STATE(_ptr) (_tls_mbsrtowcs_state)
extern _Thread_local _mbstate_t _tls_mbtowc_state;
#define _REENT_MBTOWC_STATE(_ptr) (_tls_mbtowc_state)
extern _Thread_local struct _Bigint **_tls_mp_freelist;
#define _REENT_MP_FREELIST(_ptr) (_tls_mp_freelist)
extern _Thread_local struct _Bigint *_tls_mp_p5s;
#define _REENT_MP_P5S(_ptr) (_tls_mp_p5s)
extern _Thread_local struct _Bigint *_tls_mp_result;
#define _REENT_MP_RESULT(_ptr) (_tls_mp_result)
extern _Thread_local int _tls_mp_result_k;
#define _REENT_MP_RESULT_K(_ptr) (_tls_mp_result_k)
extern _Thread_local unsigned short _tls_rand48_add;
#define _REENT_RAND48_ADD(_ptr) (_tls_rand48_add)
extern _Thread_local unsigned short _tls_rand48_mult[3];
#define _REENT_RAND48_MULT(_ptr) (_tls_rand48_mult)
extern _Thread_local unsigned short _tls_rand48_seed[3];
#define _REENT_RAND48_SEED(_ptr) (_tls_rand48_seed)
extern _Thread_local unsigned long long _tls_rand_next;
#define _REENT_RAND_NEXT(_ptr) (_tls_rand_next)
extern _Thread_local void (**_tls_sig_func)(int);
#define _REENT_SIG_FUNC(_ptr) (_tls_sig_func)
extern _Thread_local char _tls_signal_buf[_REENT_SIGNAL_SIZE];
#define _REENT_SIGNAL_BUF(_ptr) (_tls_signal_buf)
extern _Thread_local int _tls_gamma_signgam;
#define _REENT_SIGNGAM(_ptr) (_tls_gamma_signgam)
extern _Thread_local __FILE *_tls_stdin;
#define _REENT_STDIN(_ptr) (_tls_stdin)
extern _Thread_local __FILE *_tls_stdout;
#define _REENT_STDOUT(_ptr) (_tls_stdout)
extern _Thread_local __FILE *_tls_stderr;
#define _REENT_STDERR(_ptr) (_tls_stderr)
extern _Thread_local char *_tls_strtok_last;
#define _REENT_STRTOK_LAST(_ptr) (_tls_strtok_last)
extern _Thread_local struct __tm _tls_localtime_buf;
#define _REENT_TM(_ptr) (&_tls_localtime_buf)
extern _Thread_local _mbstate_t _tls_wctomb_state;
#define _REENT_WCTOMB_STATE(_ptr) (_tls_wctomb_state)
extern _Thread_local _mbstate_t _tls_wcrtomb_state;
#define _REENT_WCRTOMB_STATE(_ptr) (_tls_wcrtomb_state)
extern _Thread_local _mbstate_t _tls_wcsrtombs_state;
#define _REENT_WCSRTOMBS_STATE(_ptr) (_tls_wcsrtombs_state)

#endif /* !_REENT_THREAD_LOCAL */
# 894 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3

/* This value is used in stdlib/misc.c.  reent/reent.c has to know it
   as well to make sure the freelist is correctly free'd.  Therefore
   we define it here, rather than in stdlib/misc.c, as before. */
#define _Kmax (sizeof (size_t) << 3)

extern struct _atexit *__atexit; /* points to head of LIFO stack */
extern struct _atexit __atexit0; /* one guaranteed table, required by ANSI */

extern void (*__stdio_exit_handler) (void);

void _reclaim_reent (struct _reent *);

extern int _fwalk_sglue (struct _reent *, int (*)(struct _reent *, __FILE *),
			 struct _glue *);

#ifdef __cplusplus
}
#endif
# 913 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#endif /* _SYS_REENT_H_ */
# 914 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/reent.h" 3
#endif /* reent.h expanded by -frewrite-includes */
# 61 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 2 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/_types.h>
#endif /* expanded by -frewrite-includes */
# 61 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 62 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

_BEGIN_STD_C

#if 0 /* disabled by -frewrite-includes */
#if !defined(__FILE_defined)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 66 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
typedef __FILE FILE;
# define __FILE_defined
#endif
# 69 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

typedef _fpos_t fpos_t;
#ifdef __LARGE64_FILES
typedef _fpos64_t fpos64_t;
#endif
# 74 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifndef _OFF_T_DECLARED
typedef __off_t off_t;
#define	_OFF_T_DECLARED
#endif
# 79 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifndef _SSIZE_T_DECLARED
typedef _ssize_t ssize_t;
#define	_SSIZE_T_DECLARED
#endif
# 84 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stdio.h expanded by -frewrite-includes */
#include <sys/stdio.h>
#else /* stdio.h expanded by -frewrite-includes */
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 1 3
#ifndef _NEWLIB_STDIO_H
#define _NEWLIB_STDIO_H

#if 0 /* expanded by -frewrite-includes */
#include <sys/lock.h>
#endif /* expanded by -frewrite-includes */
# 4 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <sys/reent.h>
#endif /* expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3

/* Internal locking macros, used to protect stdio functions.  In the
   general case, expand to nothing. Use __SSTR flag in FILE _flags to
   detect if FILE is private to sprintf/sscanf class of functions; if
   set then do nothing as lock is not initialised. */
#if 0 /* disabled by -frewrite-includes */
#if !defined(_flockfile)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#ifndef __SINGLE_THREAD__
#  define _flockfile(fp) (((fp)->_flags & __SSTR) ? 0 : __lock_acquire_recursive((fp)->_lock))
#else
# 15 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#  define _flockfile(fp)	((void) 0)
#endif
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#endif
# 18 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if !defined(_funlockfile)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 20 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#ifndef __SINGLE_THREAD__
#  define _funlockfile(fp) (((fp)->_flags & __SSTR) ? 0 : __lock_release_recursive((fp)->_lock))
#else
# 23 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#  define _funlockfile(fp)	((void) 0)
#endif
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#endif
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3

#endif /* _NEWLIB_STDIO_H */
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/sys/stdio.h" 3
#endif /* stdio.h expanded by -frewrite-includes */
# 86 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 2 3

#define	__SLBF	0x0001		/* line buffered */
#define	__SNBF	0x0002		/* unbuffered */
#define	__SRD	0x0004		/* OK to read */
#define	__SWR	0x0008		/* OK to write */
	/* RD and WR are never simultaneously asserted */
#define	__SRW	0x0010		/* open for reading & writing */
#define	__SEOF	0x0020		/* found EOF */
#define	__SERR	0x0040		/* found error */
#define	__SMBF	0x0080		/* _buf is from malloc */
#define	__SAPP	0x0100		/* fdopen()ed in append mode - so must  write to end */
#define	__SSTR	0x0200		/* this is an sprintf/snprintf string */
#define	__SOPT	0x0400		/* do fseek() optimisation */
#define	__SNPT	0x0800		/* do not do fseek() optimisation */
#define	__SOFF	0x1000		/* set iff _offset is in fact correct */
#define	__SORD	0x2000		/* true => stream orientation (byte/wide) decided */
#if 0 /* disabled by -frewrite-includes */
#if defined(__CYGWIN__)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 103 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#  define __SCLE  0x4000        /* convert line endings CR/LF <-> NL */
#endif
# 105 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	__SL64	0x8000		/* is 64-bit offset large file */

/* _flags2 flags */
#define	__SNLK  0x0001		/* stdio functions do not lock streams themselves */
#define	__SWID	0x2000		/* true => stream orientation wide, false => byte, only valid if __SORD in _flags is true */

/*
 * The following three definitions are for ANSI C, which took them
 * from System V, which stupidly took internal interface macros and
 * made them official arguments to setvbuf(), without renaming them.
 * Hence, these ugly _IOxxx names are *supposed* to appear in user code.
 *
 * Although these happen to match their counterparts above, the
 * implementation does not rely on that (so these could be renumbered).
 */
#define	_IOFBF	0		/* setvbuf should set fully buffered */
#define	_IOLBF	1		/* setvbuf should set line buffered */
#define	_IONBF	2		/* setvbuf should set unbuffered */

#define	EOF	(-1)

#ifdef __BUFSIZ__
#define	BUFSIZ		__BUFSIZ__
#else
# 129 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	BUFSIZ		1024
#endif
# 131 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifdef __FOPEN_MAX__
#define FOPEN_MAX	__FOPEN_MAX__
#else
# 135 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	FOPEN_MAX	20
#endif
# 137 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifdef __FILENAME_MAX__
#define FILENAME_MAX    __FILENAME_MAX__
#else
# 141 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	FILENAME_MAX	1024
#endif
# 143 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifdef __L_tmpnam__
#define L_tmpnam	__L_tmpnam__
#else
# 147 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	L_tmpnam	FILENAME_MAX
#endif
# 149 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __BSD_VISIBLE || __XSI_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 151 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define P_tmpdir        "/tmp"
#endif
# 153 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifndef SEEK_SET
#define	SEEK_SET	0	/* set file offset to offset */
#endif
# 157 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#ifndef SEEK_CUR
#define	SEEK_CUR	1	/* set file offset to current plus offset */
#endif
# 160 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#ifndef SEEK_END
#define	SEEK_END	2	/* set file offset to EOF plus offset */
#endif
# 163 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#define	TMP_MAX		26

#define	stdin	_REENT_STDIN(_REENT)
#define	stdout	_REENT_STDOUT(_REENT)
#define	stderr	_REENT_STDERR(_REENT)

#define _stdin_r(x)	_REENT_STDIN(x)
#define _stdout_r(x)	_REENT_STDOUT(x)
#define _stderr_r(x)	_REENT_STDERR(x)

/*
 * Functions defined in ANSI C standard.
 */

#ifndef __VALIST
#ifdef __GNUC__
#define __VALIST __gnuc_va_list
#else
# 182 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define __VALIST char*
#endif
# 184 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 185 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 187 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
char *	ctermid (char *);
#endif
# 189 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNU_VISIBLE || (__XSI_VISIBLE && __XSI_VISIBLE < 600)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 190 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
char *	cuserid (char *);
#endif
# 192 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
FILE *	tmpfile (void);
char *	tmpnam (char *);
#if 0 /* disabled by -frewrite-includes */
#if __BSD_VISIBLE || __XSI_VISIBLE || __POSIX_VISIBLE >= 200112
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 195 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
char *	tempnam (const char *, const char *) __malloc_like __result_use_check;
#endif
# 197 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fclose (FILE *);
int	fflush (FILE *);
FILE *	freopen (const char *__restrict, const char *__restrict, FILE *__restrict);
void	setbuf (FILE *__restrict, char *__restrict);
int	setvbuf (FILE *__restrict, char *__restrict, int, size_t);
int	fprintf (FILE *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	fscanf (FILE *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 3)));
int	printf (const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 1, 2)));
int	scanf (const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 1, 2)));
int	sscanf (const char *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 3)));
int	vfprintf (FILE *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	vprintf (const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 1, 0)));
int	vsprintf (char *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	fgetc (FILE *);
char *  fgets (char *__restrict, int, FILE *__restrict);
int	fputc (int, FILE *);
int	fputs (const char *__restrict, FILE *__restrict);
int	getc (FILE *);
int	getchar (void);
char *  gets (char *);
int	putc (int, FILE *);
int	putchar (int);
int	puts (const char *);
int	ungetc (int, FILE *);
size_t	fread (void *__restrict, size_t _size, size_t _n, FILE *__restrict);
size_t	fwrite (const void *__restrict , size_t _size, size_t _n, FILE *);
#ifdef _LIBC
int	fgetpos (FILE *, _fpos_t *);
#else
# 234 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fgetpos (FILE *__restrict, fpos_t *__restrict);
#endif
# 236 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fseek (FILE *, long, int);
#ifdef _LIBC
int	fsetpos (FILE *, const _fpos_t *);
#else
# 240 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fsetpos (FILE *, const fpos_t *);
#endif
# 242 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
long	ftell ( FILE *);
void	rewind (FILE *);
void	clearerr (FILE *);
int	feof (FILE *);
int	ferror (FILE *);
void    perror (const char *);
#ifndef _REENT_ONLY
FILE *	fopen (const char *__restrict _name, const char *__restrict _type);
int	sprintf (char *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	remove (const char *);
int	rename (const char *, const char *);
#ifdef _LIBC
int	_rename (const char *, const char *);
#endif
# 257 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 258 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __LARGEFILE_VISIBLE || __POSIX_VISIBLE >= 200112
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 259 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#ifdef _LIBC
int	fseeko (FILE *, _off_t, int);
_off_t	ftello (FILE *);
#else
# 263 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fseeko (FILE *, off_t, int);
off_t	ftello (FILE *);
#endif
# 266 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 267 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNU_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 268 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fcloseall (void);
#endif
# 270 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#ifndef _REENT_ONLY
#if 0 /* disabled by -frewrite-includes */
#if __ISO_C_VISIBLE >= 1999
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 272 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	snprintf (char *__restrict, size_t, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	vsnprintf (char *__restrict, size_t, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	vfscanf (FILE *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 0)));
int	vscanf (const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 1, 0)));
int	vsscanf (const char *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 0)));
#endif
# 283 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __GNU_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 284 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	asprintf (char **__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	vasprintf (char **, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
#endif
# 289 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE /* Newlib-specific */
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 290 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	asiprintf (char **, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
char *	asniprintf (char *, size_t *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
char *	asnprintf (char *__restrict, size_t *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
#ifndef diprintf
int	diprintf (int, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
#endif
# 300 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fiprintf (FILE *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	fiscanf (FILE *, const char *, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 3)));
int	iprintf (const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 1, 2)));
int	iscanf (const char *, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 1, 2)));
int	siprintf (char *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	siscanf (const char *, const char *, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 3)));
int	sniprintf (char *, size_t, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	vasiprintf (char **, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
char *	vasniprintf (char *, size_t *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
char *	vasnprintf (char *, size_t *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	vdiprintf (int, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	vfiprintf (FILE *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	vfiscanf (FILE *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 0)));
int	viprintf (const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 1, 0)));
int	viscanf (const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 1, 0)));
int	vsiprintf (char *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	vsiscanf (const char *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 0)));
int	vsniprintf (char *, size_t, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
#endif /* __MISC_VISIBLE */
# 337 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif /* !_REENT_ONLY */
# 338 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

/*
 * Routines in POSIX 1003.1:2001.
 */

#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 344 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#ifndef _REENT_ONLY
FILE *	fdopen (int, const char *);
#endif
# 347 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	fileno (FILE *);
#endif
# 349 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE || __POSIX_VISIBLE >= 199209
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 350 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	pclose (FILE *);
FILE *  popen (const char *, const char *);
#endif
# 353 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __BSD_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 355 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
void    setbuffer (FILE *, char *, int);
int	setlinebuf (FILE *);
#endif
# 358 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE || (__XSI_VISIBLE && __POSIX_VISIBLE < 200112)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 360 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	getw (FILE *);
int	putw (int, FILE *);
#endif
# 363 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE || __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 364 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	getc_unlocked (FILE *);
int	getchar_unlocked (void);
void	flockfile (FILE *);
int	ftrylockfile (FILE *);
void	funlockfile (FILE *);
int	putc_unlocked (int, FILE *);
int	putchar_unlocked (int);
#endif
# 372 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

/*
 * Routines in POSIX 1003.1:200x.
 */

#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE >= 200809
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 378 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# ifndef _REENT_ONLY
#  ifndef dprintf
int	dprintf (int, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
#  endif
# 383 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
FILE *	fmemopen (void *__restrict, size_t, const char *__restrict);
/* getdelim - see __getdelim for now */
/* getline - see __getline for now */
FILE *	open_memstream (char **, size_t *);
int	vdprintf (int, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
# endif
# 390 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 391 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __ATFILE_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 392 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	renameat (int, const char *, int, const char *);
# ifdef __CYGWIN__
int	renameat2 (int, const char *, int, const char *, unsigned int);
# endif
# 396 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 397 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

/*
 * Recursive versions of the above.
 */

int	_asiprintf_r (struct _reent *, char **, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
char *	_asniprintf_r (struct _reent *, char *, size_t *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 4, 5)));
char *	_asnprintf_r (struct _reent *, char *__restrict, size_t *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 4, 5)));
int	_asprintf_r (struct _reent *, char **__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_diprintf_r (struct _reent *, int, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_dprintf_r (struct _reent *, int, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_fclose_r (struct _reent *, FILE *);
int	_fcloseall_r (struct _reent *);
FILE *	_fdopen_r (struct _reent *, int, const char *);
int	_fflush_r (struct _reent *, FILE *);
int	_fgetc_r (struct _reent *, FILE *);
int	_fgetc_unlocked_r (struct _reent *, FILE *);
char *  _fgets_r (struct _reent *, char *__restrict, int, FILE *__restrict);
char *  _fgets_unlocked_r (struct _reent *, char *__restrict, int, FILE *__restrict);
#ifdef _LIBC
int	_fgetpos_r (struct _reent *, FILE *__restrict, _fpos_t *__restrict);
int	_fsetpos_r (struct _reent *, FILE *, const _fpos_t *);
#else
# 426 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	_fgetpos_r (struct _reent *, FILE *, fpos_t *);
int	_fsetpos_r (struct _reent *, FILE *, const fpos_t *);
#endif
# 429 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
int	_fiprintf_r (struct _reent *, FILE *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_fiscanf_r (struct _reent *, FILE *, const char *, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 4)));
FILE *	_fmemopen_r (struct _reent *, void *__restrict, size_t, const char *__restrict);
FILE *	_fopen_r (struct _reent *, const char *__restrict, const char *__restrict);
FILE *	_freopen_r (struct _reent *, const char *__restrict, const char *__restrict, FILE *__restrict);
int	_fprintf_r (struct _reent *, FILE *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_fpurge_r (struct _reent *, FILE *);
int	_fputc_r (struct _reent *, int, FILE *);
int	_fputc_unlocked_r (struct _reent *, int, FILE *);
int	_fputs_r (struct _reent *, const char *__restrict, FILE *__restrict);
int	_fputs_unlocked_r (struct _reent *, const char *__restrict, FILE *__restrict);
size_t	_fread_r (struct _reent *, void *__restrict, size_t _size, size_t _n, FILE *__restrict);
size_t	_fread_unlocked_r (struct _reent *, void *__restrict, size_t _size, size_t _n, FILE *__restrict);
int	_fscanf_r (struct _reent *, FILE *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 4)));
int	_fseek_r (struct _reent *, FILE *, long, int);
int	_fseeko_r (struct _reent *, FILE *, _off_t, int);
long	_ftell_r (struct _reent *, FILE *);
_off_t	_ftello_r (struct _reent *, FILE *);
void	_rewind_r (struct _reent *, FILE *);
size_t	_fwrite_r (struct _reent *, const void *__restrict, size_t _size, size_t _n, FILE *__restrict);
size_t	_fwrite_unlocked_r (struct _reent *, const void *__restrict, size_t _size, size_t _n, FILE *__restrict);
int	_getc_r (struct _reent *, FILE *);
int	_getc_unlocked_r (struct _reent *, FILE *);
int	_getchar_r (struct _reent *);
int	_getchar_unlocked_r (struct _reent *);
char *	_gets_r (struct _reent *, char *);
int	_iprintf_r (struct _reent *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	_iscanf_r (struct _reent *, const char *, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 3)));
FILE *	_open_memstream_r (struct _reent *, char **, size_t *);
void	_perror_r (struct _reent *, const char *);
int	_printf_r (struct _reent *, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 2, 3)));
int	_putc_r (struct _reent *, int, FILE *);
int	_putc_unlocked_r (struct _reent *, int, FILE *);
int	_putchar_unlocked_r (struct _reent *, int);
int	_putchar_r (struct _reent *, int);
int	_puts_r (struct _reent *, const char *);
int	_remove_r (struct _reent *, const char *);
int	_rename_r (struct _reent *,
			   const char *_old, const char *_new);
int	_scanf_r (struct _reent *, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 3)));
int	_siprintf_r (struct _reent *, char *, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_siscanf_r (struct _reent *, const char *, const char *, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 4)));
int	_sniprintf_r (struct _reent *, char *, size_t, const char *, ...)
               _ATTRIBUTE ((__format__ (__printf__, 4, 5)));
int	_snprintf_r (struct _reent *, char *__restrict, size_t, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 4, 5)));
int	_sprintf_r (struct _reent *, char *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__printf__, 3, 4)));
int	_sscanf_r (struct _reent *, const char *__restrict, const char *__restrict, ...)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 4)));
char *	_tempnam_r (struct _reent *, const char *, const char *);
FILE *	_tmpfile_r (struct _reent *);
char *	_tmpnam_r (struct _reent *, char *);
int	_ungetc_r (struct _reent *, int, FILE *);
int	_vasiprintf_r (struct _reent *, char **, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
char *	_vasniprintf_r (struct _reent*, char *, size_t *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 4, 0)));
char *	_vasnprintf_r (struct _reent*, char *, size_t *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 4, 0)));
int	_vasprintf_r (struct _reent *, char **, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vdiprintf_r (struct _reent *, int, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vdprintf_r (struct _reent *, int, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vfiprintf_r (struct _reent *, FILE *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vfiscanf_r (struct _reent *, FILE *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 0)));
int	_vfprintf_r (struct _reent *, FILE *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vfscanf_r (struct _reent *, FILE *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 0)));
int	_viprintf_r (struct _reent *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	_viscanf_r (struct _reent *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 0)));
int	_vprintf_r (struct _reent *, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 2, 0)));
int	_vscanf_r (struct _reent *, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 2, 0)));
int	_vsiprintf_r (struct _reent *, char *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vsiscanf_r (struct _reent *, const char *, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 0)));
int	_vsniprintf_r (struct _reent *, char *, size_t, const char *, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 4, 0)));
int	_vsnprintf_r (struct _reent *, char *__restrict, size_t, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 4, 0)));
int	_vsprintf_r (struct _reent *, char *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__printf__, 3, 0)));
int	_vsscanf_r (struct _reent *, const char *__restrict, const char *__restrict, __VALIST)
               _ATTRIBUTE ((__format__ (__scanf__, 3, 0)));

/* Other extensions.  */

int	fpurge (FILE *);
ssize_t __getdelim (char **, size_t *, int, FILE *);
ssize_t __getline (char **, size_t *, FILE *);

#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 541 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
void	clearerr_unlocked (FILE *);
int	feof_unlocked (FILE *);
int	ferror_unlocked (FILE *);
int	fileno_unlocked (FILE *);
int	fflush_unlocked (FILE *);
int	fgetc_unlocked (FILE *);
int	fputc_unlocked (int, FILE *);
size_t	fread_unlocked (void *__restrict, size_t _size, size_t _n, FILE *__restrict);
size_t	fwrite_unlocked (const void *__restrict , size_t _size, size_t _n, FILE *);
#endif
# 551 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNU_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 553 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
char *  fgets_unlocked (char *__restrict, int, FILE *__restrict);
int	fputs_unlocked (const char *__restrict, FILE *__restrict);
#endif
# 556 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifdef __LARGE64_FILES
#if 0 /* disabled by -frewrite-includes */
#if !defined(__CYGWIN__) || defined(_LIBC)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 559 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
FILE *	fdopen64 (int, const char *);
FILE *  fopen64 (const char *, const char *);
FILE *  freopen64 (const char *, const char *, FILE *);
_off64_t ftello64 (FILE *);
_off64_t fseeko64 (FILE *, _off64_t, int);
int     fgetpos64 (FILE *, _fpos64_t *);
int     fsetpos64 (FILE *, const _fpos64_t *);
FILE *  tmpfile64 (void);

FILE *	_fdopen64_r (struct _reent *, int, const char *);
FILE *  _fopen64_r (struct _reent *,const char *, const char *);
FILE *  _freopen64_r (struct _reent *, const char *, const char *, FILE *);
_off64_t _ftello64_r (struct _reent *, FILE *);
_off64_t _fseeko64_r (struct _reent *, FILE *, _off64_t, int);
int     _fgetpos64_r (struct _reent *, FILE *, _fpos64_t *);
int     _fsetpos64_r (struct _reent *, FILE *, const _fpos64_t *);
FILE *  _tmpfile64_r (struct _reent *);
#endif /* !__CYGWIN__ */
# 577 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif /* __LARGE64_FILES */
# 578 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

/*
 * Routines internal to the implementation.
 */

int	__srget_r (struct _reent *, FILE *);
int	__swbuf_r (struct _reent *, int, FILE *);

/*
 * Stdio function-access interface.
 */

#if 0 /* disabled by -frewrite-includes */
#if __BSD_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 591 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# ifdef __LARGE64_FILES
FILE	*funopen (const void *__cookie,
		int (*__readfn)(void *__c, char *__buf,
				_READ_WRITE_BUFSIZE_TYPE __n),
		int (*__writefn)(void *__c, const char *__buf,
				 _READ_WRITE_BUFSIZE_TYPE __n),
		_fpos64_t (*__seekfn)(void *__c, _fpos64_t __off, int __whence),
		int (*__closefn)(void *__c));
FILE	*_funopen_r (struct _reent *, const void *__cookie,
		int (*__readfn)(void *__c, char *__buf,
				_READ_WRITE_BUFSIZE_TYPE __n),
		int (*__writefn)(void *__c, const char *__buf,
				 _READ_WRITE_BUFSIZE_TYPE __n),
		_fpos64_t (*__seekfn)(void *__c, _fpos64_t __off, int __whence),
		int (*__closefn)(void *__c));
# else
# 607 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
FILE	*funopen (const void *__cookie,
		int (*__readfn)(void *__cookie, char *__buf,
				_READ_WRITE_BUFSIZE_TYPE __n),
		int (*__writefn)(void *__cookie, const char *__buf,
				 _READ_WRITE_BUFSIZE_TYPE __n),
		fpos_t (*__seekfn)(void *__cookie, fpos_t __off, int __whence),
		int (*__closefn)(void *__cookie));
FILE	*_funopen_r (struct _reent *, const void *__cookie,
		int (*__readfn)(void *__cookie, char *__buf,
				_READ_WRITE_BUFSIZE_TYPE __n),
		int (*__writefn)(void *__cookie, const char *__buf,
				 _READ_WRITE_BUFSIZE_TYPE __n),
		fpos_t (*__seekfn)(void *__cookie, fpos_t __off, int __whence),
		int (*__closefn)(void *__cookie));
# endif /* !__LARGE64_FILES */
# 622 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

# define	fropen(__cookie, __fn) funopen(__cookie, __fn, NULL, NULL, NULL)
# define	fwopen(__cookie, __fn) funopen(__cookie, NULL, __fn, NULL, NULL)
#endif /* __BSD_VISIBLE */
# 626 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNU_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 628 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
typedef ssize_t cookie_read_function_t(void *__cookie, char *__buf, size_t __n);
typedef ssize_t cookie_write_function_t(void *__cookie, const char *__buf,
					size_t __n);
# ifdef __LARGE64_FILES
typedef int cookie_seek_function_t(void *__cookie, _off64_t *__off,
				   int __whence);
# else
# 635 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
typedef int cookie_seek_function_t(void *__cookie, off_t *__off, int __whence);
# endif /* !__LARGE64_FILES */
# 637 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
typedef int cookie_close_function_t(void *__cookie);
typedef struct
{
  /* These four struct member names are dictated by Linux; hopefully,
     they don't conflict with any macros.  */
  cookie_read_function_t  *read;
  cookie_write_function_t *write;
  cookie_seek_function_t  *seek;
  cookie_close_function_t *close;
} cookie_io_functions_t;
FILE *fopencookie (void *__cookie,
		const char *__mode, cookie_io_functions_t __functions);
FILE *_fopencookie_r (struct _reent *, void *__cookie,
		const char *__mode, cookie_io_functions_t __functions);
#endif /* __GNU_VISIBLE */
# 652 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifndef __CUSTOM_FILE_IO__
/*
 * The __sfoo macros are here so that we can 
 * define function versions in the C library.
 */
#define       __sgetc_raw_r(__ptr, __f) (--(__f)->_r < 0 ? __srget_r(__ptr, __f) : (int)(*(__f)->_p++))

#ifdef __SCLE
/*  For a platform with CR/LF, additional logic is required by
  __sgetc_r which would otherwise simply be a macro; therefore we
  use an inlined function.  The function is only meant to be inlined
  in place as used and the function body should never be emitted.  

  There are two possible means to this end when compiling with GCC,
  one when compiling with a standard C99 compiler, and for other
  compilers we're just stuck.  At the moment, this issue only
  affects the Cygwin target, so we'll most likely be using GCC. */

_ELIDABLE_INLINE int __sgetc_r(struct _reent *__ptr, FILE *__p);

_ELIDABLE_INLINE int __sgetc_r(struct _reent *__ptr, FILE *__p)
  {
    int __c = __sgetc_raw_r(__ptr, __p);
    if ((__p->_flags & __SCLE) && (__c == '\r'))
      {
      int __c2 = __sgetc_raw_r(__ptr, __p);
      if (__c2 == '\n')
        __c = __c2;
      else
        ungetc(__c2, __p);
      }
    return __c;
  }
#else
# 687 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define __sgetc_r(__ptr, __p) __sgetc_raw_r(__ptr, __p)
#endif
# 689 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#ifdef __GNUC__
_ELIDABLE_INLINE int __sputc_r(struct _reent *_ptr, int _c, FILE *_p) {
#ifdef __SCLE
	if ((_p->_flags & __SCLE) && _c == '\n')
	  __sputc_r (_ptr, '\r', _p);
#endif
# 696 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
	if (--_p->_w >= 0 || (_p->_w >= _p->_lbfsize && (char)_c != '\n'))
		return (*_p->_p++ = _c);
	else
		return (__swbuf_r(_ptr, _c, _p));
}
#else
# 702 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
/*
 * This has been tuned to generate reasonable code on the vax using pcc
 */
#define       __sputc_raw_r(__ptr, __c, __p) \
	(--(__p)->_w < 0 ? \
		(__p)->_w >= (__p)->_lbfsize ? \
			(*(__p)->_p = (__c)), *(__p)->_p != '\n' ? \
				(int)*(__p)->_p++ : \
				__swbuf_r(__ptr, '\n', __p) : \
			__swbuf_r(__ptr, (int)(__c), __p) : \
		(*(__p)->_p = (__c), (int)*(__p)->_p++))
#ifdef __SCLE
#define __sputc_r(__ptr, __c, __p) \
        ((((__p)->_flags & __SCLE) && ((__c) == '\n')) \
          ? __sputc_raw_r(__ptr, '\r', (__p)) : 0 , \
        __sputc_raw_r((__ptr), (__c), (__p)))
#else
# 719 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define __sputc_r(__ptr, __c, __p) __sputc_raw_r(__ptr, __c, __p)
#endif
# 721 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 722 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#define	__sfeof(p)	((int)(((p)->_flags & __SEOF) != 0))
#define	__sferror(p)	((int)(((p)->_flags & __SERR) != 0))
#define	__sclearerr(p)	((void)((p)->_flags &= ~(__SERR|__SEOF)))
#define	__sfileno(p)	((p)->_file)

#ifndef __cplusplus
#ifndef _REENT_SMALL
#define	feof(p)		__sfeof(p)
#define	ferror(p)	__sferror(p)
#define	clearerr(p)	__sclearerr(p)

#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 735 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	feof_unlocked(p)	__sfeof(p)
#define	ferror_unlocked(p)	__sferror(p)
#define	clearerr_unlocked(p)	__sclearerr(p)
#endif /* __MISC_VISIBLE */
# 739 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif /* _REENT_SMALL */
# 740 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if 0 /* __POSIX_VISIBLE - FIXME: must initialize stdio first, use fn */
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 742 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	fileno(p)	__sfileno(p)
#endif
# 744 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

static __inline int
_getchar_unlocked(void)
{
	struct _reent *_ptr;

	_ptr = _REENT;
	return (__sgetc_r(_ptr, _stdin_r(_ptr)));
}

static __inline int
_putchar_unlocked(int _c)
{
	struct _reent *_ptr;

	_ptr = _REENT;
	return (__sputc_r(_ptr, _c, _stdout_r(_ptr)));
}

#ifdef __SINGLE_THREAD__
#define	getc(_p)	__sgetc_r(_REENT, _p)
#define	putc(_c, _p)	__sputc_r(_REENT, _c, _p)
#define	getchar()	_getchar_unlocked()
#define	putchar(_c)	_putchar_unlocked(_c)
#endif /* __SINGLE_THREAD__ */
# 769 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE || __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 771 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	getchar_unlocked()	_getchar_unlocked()
#define	putchar_unlocked(_c)	_putchar_unlocked(_c)
#endif
# 774 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif /* __cplusplus */
# 775 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 777 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
/* fast always-buffered version, true iff error */
#define	fast_putc(x,p) (--(p)->_w < 0 ? \
	__swbuf_r(_REENT, (int)(x), p) == EOF : (*(p)->_p = (x), (p)->_p++, 0))
#endif
# 781 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#if 0 /* disabled by -frewrite-includes */
#if __GNU_VISIBLE || (__XSI_VISIBLE && __XSI_VISIBLE < 600)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 783 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	L_cuserid	9		/* posix says it goes in stdio.h :( */
#endif
# 785 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* disabled by -frewrite-includes */
#if __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 786 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define L_ctermid       16
#endif
# 788 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#else /* __CUSTOM_FILE_IO__ */
# 790 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#define	getchar()	getc(stdin)
#define	putchar(x)	putc(x, stdout)

#if 0 /* disabled by -frewrite-includes */
#if __MISC_VISIBLE || __POSIX_VISIBLE
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 795 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#define	getchar_unlocked()	getc_unlocked(stdin)
#define	putchar_unlocked(x)	putc_unlocked(x, stdout)
#endif
# 798 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#endif /* !__CUSTOM_FILE_IO__ */
# 800 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

_END_STD_C

#if 0 /* disabled by -frewrite-includes */
#if __SSP_FORTIFY_LEVEL > 0
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 804 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#if 0 /* expanded by -frewrite-includes */
#include <ssp/stdio.h>
#endif /* expanded by -frewrite-includes */
# 804 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
# 805 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif
# 806 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3

#endif /* _STDIO_H_ */
# 808 "/var/tmp/ga87puy/isaac-demo-new/install/gnu_cfu/riscv32-unknown-elf/include/stdio.h" 3
#endif /* stdio.h expanded by -frewrite-includes */
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h" 2
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* stdarg.h expanded by -frewrite-includes */
#include <stdarg.h>
#else /* stdarg.h expanded by -frewrite-includes */
# 6 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 1 3
/*===---- stdarg.h - Variable argument handling ----------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

/*
 * This header is designed to be included multiple times. If any of the __need_
 * macros are defined, then only that subset of interfaces are provided. This
 * can be useful for POSIX headers that need to not expose all of stdarg.h, but
 * need to use some of its interfaces. Otherwise this header provides all of
 * the expected interfaces.
 *
 * When clang modules are enabled, this header is a textual header to support
 * the multiple include behavior. As such, it doesn't directly declare anything
 * so that it doesn't add duplicate declarations to all of its includers'
 * modules.
 */
#if 0 /* disabled by -frewrite-includes */
#if defined(__MVS__) && __has_include_next(<stdarg.h>)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need___va_list
#undef __need_va_list
#undef __need_va_arg
#undef __need___va_copy
#undef __need_va_copy
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg_header_macro.h>
#endif /* expanded by -frewrite-includes */
# 28 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#if 0 /* expanded by -frewrite-includes */
#include_next <stdarg.h>
#endif /* expanded by -frewrite-includes */
# 29 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 30 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#else
# 32 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#if 0 /* disabled by -frewrite-includes */
#if !defined(__need___va_list) && !defined(__need_va_list) &&                  \
    !defined(__need_va_arg) && !defined(__need___va_copy) &&                   \
    !defined(__need_va_copy)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 35 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#define __need___va_list
#define __need_va_list
#define __need_va_arg
#define __need___va_copy
/* GCC always defines __va_copy, but does not define va_copy unless in c99 mode
 * or -ansi is not specified, since it was not part of C90.
 */
#if 0 /* disabled by -frewrite-includes */
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L) ||              \
    (defined(__cplusplus) && __cplusplus >= 201103L) ||                        \
    !defined(__STRICT_ANSI__)
#endif
#endif /* disabled by -frewrite-includes */
#if 1 /* evaluated by -frewrite-includes */
# 45 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#define __need_va_copy
#endif
# 47 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stdarg_header_macro.h expanded by -frewrite-includes */
#include <__stdarg_header_macro.h>
#else /* __stdarg_header_macro.h expanded by -frewrite-includes */
# 47 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_header_macro.h" 1 3
/*===---- __stdarg_header_macro.h ------------------------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __STDARG_H
#define __STDARG_H
#endif
# 13 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_header_macro.h" 3
#endif /* __stdarg_header_macro.h expanded by -frewrite-includes */
# 48 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 2 3
#endif
# 49 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need___va_list
#if 0 /* expanded by -frewrite-includes */
#include <__stdarg___gnuc_va_list.h>
#endif /* expanded by -frewrite-includes */
# 51 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 52 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#undef __need___va_list
#endif /* defined(__need___va_list) */
# 54 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need_va_list
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stdarg_va_list.h expanded by -frewrite-includes */
#include <__stdarg_va_list.h>
#else /* __stdarg_va_list.h expanded by -frewrite-includes */
# 56 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_list.h" 1 3
/*===---- __stdarg_va_list.h - Definition of va_list -----------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef _VA_LIST
#define _VA_LIST
typedef __builtin_va_list va_list;
#endif
# 14 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_list.h" 3
#endif /* __stdarg_va_list.h expanded by -frewrite-includes */
# 57 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 2 3
#undef __need_va_list
#endif /* defined(__need_va_list) */
# 59 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need_va_arg
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stdarg_va_arg.h expanded by -frewrite-includes */
#include <__stdarg_va_arg.h>
#else /* __stdarg_va_arg.h expanded by -frewrite-includes */
# 61 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_arg.h" 1 3
/*===---- __stdarg_va_arg.h - Definitions of va_start, va_arg, va_end-------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef va_arg

#if 0 /* disabled by -frewrite-includes */
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 13 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_arg.h" 3
/* C23 uses a special builtin. */
#define va_start(...) __builtin_c23_va_start(__VA_ARGS__)
#else
# 16 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_arg.h" 3
/* Versions before C23 do require the second parameter. */
#define va_start(ap, param) __builtin_va_start(ap, param)
#endif
# 19 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_arg.h" 3
#define va_end(ap) __builtin_va_end(ap)
#define va_arg(ap, type) __builtin_va_arg(ap, type)

#endif
# 23 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_arg.h" 3
#endif /* __stdarg_va_arg.h expanded by -frewrite-includes */
# 62 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 2 3
#undef __need_va_arg
#endif /* defined(__need_va_arg) */
# 64 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need___va_copy
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stdarg___va_copy.h expanded by -frewrite-includes */
#include <__stdarg___va_copy.h>
#else /* __stdarg___va_copy.h expanded by -frewrite-includes */
# 66 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg___va_copy.h" 1 3
/*===---- __stdarg___va_copy.h - Definition of __va_copy -------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __va_copy
#define __va_copy(d, s) __builtin_va_copy(d, s)
#endif
# 13 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg___va_copy.h" 3
#endif /* __stdarg___va_copy.h expanded by -frewrite-includes */
# 67 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 2 3
#undef __need___va_copy
#endif /* defined(__need___va_copy) */
# 69 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#ifdef __need_va_copy
#if defined(__CLANG_REWRITTEN_INCLUDES) || defined(__CLANG_REWRITTEN_SYSTEM_INCLUDES) /* __stdarg_va_copy.h expanded by -frewrite-includes */
#include <__stdarg_va_copy.h>
#else /* __stdarg_va_copy.h expanded by -frewrite-includes */
# 71 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
# 1 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_copy.h" 1 3
/*===---- __stdarg_va_copy.h - Definition of va_copy------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef va_copy
#define va_copy(dest, src) __builtin_va_copy(dest, src)
#endif
# 13 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/__stdarg_va_copy.h" 3
#endif /* __stdarg_va_copy.h expanded by -frewrite-includes */
# 72 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 2 3
#undef __need_va_copy
#endif /* defined(__need_va_copy) */
# 74 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3

#endif /* __MVS__ */
# 76 "/var/tmp/ga87puy/isaac-demo-new/llvm-project-22/build/lib/clang/22/include/stdarg.h" 3
#endif /* stdarg.h expanded by -frewrite-includes */
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h" 2

#ifdef MLONMCU_TARGET_HOST_X86
#define HAS_CYCLES 1
#define HAS_INSTRUCTIONS 0
#define HAS_TIME 1
#else
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#define HAS_CYCLES 1
#define HAS_INSTRUCTIONS 1
// #define HAS_TIME 1
#endif  // MLONMCU_TARGET_HOST_X86
# 17 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"

uint64_t target_cycles();
uint64_t target_instructions();
uint64_t target_time();

__attribute__((weak)) void target_init() {}
__attribute__((weak)) void target_deinit() {}
#if 0 /* disabled by -frewrite-includes */
#if defined(MLONMCU_TARGET_ARA)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#if 0 /* expanded by -frewrite-includes */
#include "printf.h"
#endif /* expanded by -frewrite-includes */
# 25 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#define target_printf printf
#if 0 /* disabled by -frewrite-includes */
#if 0
#elif defined(MLONMCU_TARGET_VICUNA)
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#if 0 /* expanded by -frewrite-includes */
#include "uart.h"
#endif /* expanded by -frewrite-includes */
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
# 29 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#define target_printf uart_printf
#else
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#define target_printf printf
#endif
# 33 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
// __attribute__((weak)) void target_printf(const char* format, ...) {
//     va_list argptr;
//     va_start(argptr, format);
//     vprintf(format, argptr);
//     va_end(argptr);
// }

#endif  // LIB_TARGETS_TARGET_H
# 41 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/targets/./target.h"
#endif /* target.h expanded by -frewrite-includes */
# 5 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h" 2
// void mlonmcu_printf(const char* format, ...);

#ifdef STRIP_STRINGS
#define mlonmcu_printf(format, ...)
#else
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h"
#define mlonmcu_printf target_printf
#endif  // STRIP_STRINGS
# 12 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h"

#ifdef _DEBUG
#define DBGPRINTF(format, ...) mlonmcu_printf(format, ##__VA_ARGS__)
#else
# 16 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h"
#define DBGPRINTF(format, ...)
#endif
# 18 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h"

#endif
# 20 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/support/./printing.h"
#endif /* printing.h expanded by -frewrite-includes */
# 8 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h" 2

#if 0 /* expanded by -frewrite-includes */
#include "target.h"
#endif /* expanded by -frewrite-includes */
# 9 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define MAX_NUM_BENCH 4

#define INIT 0
#define RUN 1
#define TOTAL 2
#define DEINIT 3

#if 0 /* disabled by -frewrite-includes */
#if HAS_CYCLES && HAS_INSTRUCTIONS && HAS_TIME
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define MAX_METRICS_IDX 2
#define CYCLES 0
#define INSTRUCTIONS 1
#define TIME 2

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif HAS_CYCLES && HAS_INSTRUCTIONS
#endif
#endif /* disabled by -frewrite-includes */
#elif 1 /* evaluated by -frewrite-includes */
# 26 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define CYCLES 0
#define INSTRUCTIONS 1
#define MAX_METRICS_IDX 1

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif HAS_CYCLES && HAS_TIME
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 32 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define CYCLES 0
#define TIME 1
#define MAX_METRICS_IDX 1

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif HAS_INSTRUCTIONS && HAS_TIME
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 38 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define INSTRUCTIONS 0
#define TIME 1
#define MAX_METRICS_IDX 1

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif HAS_CYCLES
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 44 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define CYCLES 0
#define MAX_METRICS_IDX 0

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif HAS_INSTRUCTIONS
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 49 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define INSTRUCTIONS 0
#define MAX_METRICS_IDX 0

#if 0 /* disabled by -frewrite-includes */
#if 0
#elif HAS_TIME
#endif
#endif /* disabled by -frewrite-includes */
#elif 0 /* evaluated by -frewrite-includes */
# 54 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define TIME 0
#define MAX_METRICS_IDX 0

#else
# 59 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define MAX_METRICS_IDX -1

#endif
# 63 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define BENCH_NAME_0 "Setup"
#define BENCH_NAME_1 "Run"
#define BENCH_NAME_2 "Total"
#define BENCH_NAME_3 "Deinit"

#define BENCH_METRIC_CYCLES 0
#define BENCH_METRIC_INSTRUCTIONS 1
#define BENCH_METRIC_TIME 2
#define BENCH_METRIC_0 "Cycles"
#define BENCH_METRIC_1 "Instructions"
#define BENCH_METRIC_2 "Runtime [us]"

#define BENCH_TYPE_0 uint64_t
#define BENCH_TYPE_1 uint64_t
#define BENCH_TYPE_2 uint64_t

#if 0 /* disabled by -frewrite-includes */
#if defined(MLONMCU_TARGET_VICUNA)
#endif
#endif /* disabled by -frewrite-includes */
#if 0 /* evaluated by -frewrite-includes */
# 81 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
#define BENCH_FMT_0 "u"
#define BENCH_FMT_1 "u"
#define BENCH_FMT_2 "u"
#else
# 85 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
#define BENCH_FMT_0 PRIu64
#define BENCH_FMT_1 PRIu64
#define BENCH_FMT_2 PRIu64
#endif
# 89 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define BENCH_FUNC_0 target_cycles
#define BENCH_FUNC_1 target_instructions
#define BENCH_FUNC_2 target_time

#define BENCH_NAME2(index) BENCH_NAME_ ## index
#define BENCH_NAME(index) BENCH_NAME2(index)
#define BENCH_METRIC2(index) BENCH_METRIC_ ## index
#define BENCH_METRIC(index) BENCH_METRIC2(index)
#define BENCH_TYPE2(index) BENCH_TYPE_ ## index
#define BENCH_TYPE(index) BENCH_TYPE2(index)
#define BENCH_FMT2(index) BENCH_FMT_ ## index
#define BENCH_FMT(index) BENCH_FMT2(index)
#define BENCH_FUNC2(index) BENCH_FUNC_ ## index
#define BENCH_FUNC(index) BENCH_FUNC2(index)

// #define BENCH_DATA3(metric) BENCH_METRIC(metric)
#define BENCH_DATA2(metric) temp_ ## metric
#define BENCH_DATA(metric) BENCH_DATA2(metric)
#define BENCH_DATA_DECL(metric) static BENCH_TYPE(metric) BENCH_DATA(metric)[MAX_NUM_BENCH] = {0};

#ifdef CYCLES
BENCH_DATA_DECL(BENCH_METRIC_CYCLES)
#endif
# 113 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
#ifdef INSTRUCTIONS
BENCH_DATA_DECL(BENCH_METRIC_INSTRUCTIONS)
#endif
# 116 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
#ifdef TIME
BENCH_DATA_DECL(BENCH_METRIC_TIME)
#endif
# 119 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"

#define PRINT_BENCH(metric) mlonmcu_printf("# %s " BENCH_METRIC(metric) ": %" BENCH_FMT(metric) "\n", bench_names[index], BENCH_DATA(metric)[index]);

static char* bench_names[MAX_NUM_BENCH] = {
    BENCH_NAME_0,
    BENCH_NAME_1,
    BENCH_NAME_2,
    BENCH_NAME_3,
};


void start_bench(size_t index);
void stop_bench(size_t index);
void print_bench(size_t index);

#endif  // LIB_BENCH_BENCH_H
# 135 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.h"
#endif /* bench.h expanded by -frewrite-includes */
# 2 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c" 2

void start_bench(size_t index) {
#ifdef CYCLES
    BENCH_TYPE(BENCH_METRIC_CYCLES) cycles = BENCH_FUNC(BENCH_METRIC_CYCLES)();
#endif
# 7 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef INSTRUCTIONS
    BENCH_TYPE(BENCH_METRIC_INSTRUCTIONS) instructions = BENCH_FUNC(BENCH_METRIC_INSTRUCTIONS)();
#endif
# 10 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef TIME
    BENCH_TYPE(BENCH_METRIC_TIME) time = BENCH_FUNC(BENCH_METRIC_TIME)();
#endif
# 13 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef CYCLES
    BENCH_DATA(BENCH_METRIC_CYCLES)[index] = cycles;
#endif
# 16 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef INSTRUCTIONS
    BENCH_DATA(BENCH_METRIC_INSTRUCTIONS)[index] = instructions;
#endif
# 19 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef TIME
    BENCH_DATA(BENCH_METRIC_TIME)[index] = time;
#endif
# 22 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
}

void stop_bench(size_t index) {
#ifdef CYCLES
    BENCH_TYPE(BENCH_METRIC_CYCLES) cycles = BENCH_FUNC(BENCH_METRIC_CYCLES)();
#endif
# 28 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef INSTRUCTIONS
    BENCH_TYPE(BENCH_METRIC_INSTRUCTIONS) instructions = BENCH_FUNC(BENCH_METRIC_INSTRUCTIONS)();
#endif
# 31 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef TIME
    BENCH_TYPE(BENCH_METRIC_TIME) time = BENCH_FUNC(BENCH_METRIC_TIME)();
#endif
# 34 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
    // TODO: check for overflow
#ifdef CYCLES
    BENCH_DATA(BENCH_METRIC_CYCLES)[index] = cycles - BENCH_DATA(BENCH_METRIC_CYCLES)[index];
#endif
# 38 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef INSTRUCTIONS
    BENCH_DATA(BENCH_METRIC_INSTRUCTIONS)[index] = instructions - BENCH_DATA(BENCH_METRIC_INSTRUCTIONS)[index];
#endif
# 41 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef TIME
    BENCH_DATA(BENCH_METRIC_TIME)[index] = time - BENCH_DATA(BENCH_METRIC_TIME)[index];
#endif
# 44 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
}

void print_bench(size_t index) {
#ifdef CYCLES
    PRINT_BENCH(BENCH_METRIC_CYCLES)
#endif
# 50 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef INSTRUCTIONS
    PRINT_BENCH(BENCH_METRIC_INSTRUCTIONS)
#endif
# 53 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
#ifdef TIME
    PRINT_BENCH(BENCH_METRIC_TIME)
#endif
# 56 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/mlif/lib/bench/bench.c"
}
