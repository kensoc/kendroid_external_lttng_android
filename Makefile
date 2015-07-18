#LOCAL_PATH= $(call my-dir)

$(info Makefile ->> Local path is $(LOCAL_PATH))
$(info Makefile ->> top dir is $(TOPDIR))
$(info Makefile ->> Houst out executable is $(HOST_OUT_EXECUTABLES))
$(info Makefile ->> Target copy out system is $(TARGET_COPY_OUT_SYSTEM))
$(info Makefile ->> all paths can be seen at TOPDIR/build/core/envsetup.mk)

# Build all lttng modules
all_modules: lttng-modules lttng-tools

# Clean all lttng modules
clean:lttng-modules-clean

lttng-modules: 
	echo "lttng-modules started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules && \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules_install && \
	echo "lttng-modules finished";

lttng-tools:
	echo "lttng-modules started"; \
	cd lttng-tools; \
	./bootstrap
	./configure
	make
	make install
	sudo ldconfig
	#LOCAL_CLFAGS += -DLIBXML_SCHEMAS_ENABLED
	
lttng-modules-clean:
	echo "lttng-modules-clean started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) clean && \
	echo "lttng-modules-clean finished";

	
	
