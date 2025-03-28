####################################################################
#  SLICOT main makefile for Unix-like machines                     #
#  Top Level Makefile for generating SLICOT Library object file,   #
#  the auxiliary library file, and linking and running the example #
#  programs.                                                       #
#                                                                  #
#  SLICOT, Release 5.9                          ./slicot/makefile  #
#  Vasile Sima                                                     #
#  October 31, 1996                                                #
#  Revised Dec. 7, 1999; Feb. 14, 2005, Dec. 28, 2022, Feb. 2023.  #
#          Feb. 2024.                                              #
####################################################################
#
#  This makefile creates/updates the SLICOT Library object file, the 
#  auxiliary library, and compiles, links, and runs the example 
#  programs for the SLICOT Library. To perform all these actions,
#  enter
#       make
#
#  To create/update the libraries, enter 
#       make lib
#
#  To compile, link, and run the example programs, enter 
#       make example
#
#  To remove the object files for SLICOT routines and auxiliary
#  routines, enter
#       make cleanlib
#
#  To remove the files with the computed results (*.exa), enter
#       make cleanexample
#
#  To remove the object files for SLICOT routines and auxiliary
#  routines, as well as the files with the computed results (*.exa),
#  enter
#       make clean
#
####################################################################

#  Modify the FORTRAN and OPTS definitions to the desired compiler
#  and desired compiler options for your machine.  NOOPT refers to
#  the compiler options desired when NO OPTIMIZATION is selected.
#
FC ?= gfortran
OPTS = -O3 

#  The archiver and the flag(s) to use when building an archive
#  (library).  If your system has no ranlib, set RANLIB = echo.
#
ARCH = ar
ARCHFLAGS = cr

#  The location of the libraries to which you will link.  (The
#  machine-specific, optimized BLAS library should be used whenever
#  possible.)
#

BUILD_DIR ?= build

LPKAUXLIB    = liblpkaux.a
SLICOTLIB    = libslicot.a

AUX_SRC = $(wildcard src_aux/*.f)
AUX_OBJS = $(patsubst src_aux/%.f, $(BUILD_DIR)/src_aux/%.o, $(AUX_SRC))

MAIN_SRC = $(wildcard src/*.f)
MAIN_OBJS = $(patsubst src/%.f, $(BUILD_DIR)/src/%.o, $(MAIN_SRC))


all: main_lib lib_aux

main_lib: $(MAIN_OBJS)
	$(ARCH) $(ARCHFLAGS) $(BUILD_DIR)/$(SLICOTLIB) $(MAIN_OBJS)

$(BUILD_DIR)/src/%.o: src/%.f | $(BUILD_DIR)
	$(FC) $(OPTS) -c $< -o $@

lib_aux: $(AUX_OBJS)
	$(ARCH) $(ARCHFLAGS) $(BUILD_DIR)/$(LPKAUXLIB) $(AUX_OBJS)

$(BUILD_DIR)/src_aux/%.o: src_aux/%.f | $(BUILD_DIR)
	$(FC) $(OPTS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)/src
	mkdir -p $(BUILD_DIR)/src_aux