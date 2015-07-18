#LOCAL_PATH= $(call my-dir)

$(info Makefile ->> Local path is $(LOCAL_PATH))

# Build all lttng modules
all_modules: lttng-modules

# Clean all lttng modules
clean:lttng-modules-clean

lttng-modules: 
	echo "lttng-modules started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules && \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules_install && \
	echo "lttng-modules finished";

lttng-modules-clean:
	echo "lttng-modules-clean started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) clean && \
	echo "lttng-modules-clean finished";
