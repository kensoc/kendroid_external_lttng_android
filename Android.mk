#
#==============================================================================
#	File:		Android.mk
#	Author:		Hardik Patel
#	Date:		07/17/2015
#	Version:	0.1
#	Usage:		This make file builds all lttng and its modules for 
#			android build system.
#	copyright:
#===============================================================================
#
LOCAL_PATH := $(call my-dir)

include $(call all-makefiles-under, $(LOCAL_PATH))
