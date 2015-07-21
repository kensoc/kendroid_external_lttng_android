#LOCAL_PATH= $(call my-dir)

$(info @HPatel - Makefile ->> Local path is $(LOCAL_PATH))
$(info @HPatel - Makefile ->> product out dir is $(PRODUCT_OUT))
$(info @HPatel - Makefile ->> Target Out dir is $(TARGET_OUT))
$(info @HPatel - Makefile ->> Target out executables dir is $(TARGET_OUT_EXECUTABLES))
$(info @HPatel - Makefile ->> Target out optional exuecutables dir is $(TARGET_OUT_OPTIONAL_EXECUTABLES))
$(info @HPatel - Makefile ->> Target out shared libs dir is $(TARGET_OUT_SHARED_LIBRARIES))
$(info @HPatel - Makefile ->> Target out etc dir is $(TARGET_OUT_ETC))
$(info @HPatel - Makefile ->> Target out java framework dir is $(TARGET_OUT_JAVA_LIBRARIES))
$(info @HPatel - Makefile ->> Target out apps dir is $(TARGET_OUT_APPS))

#include makefiles here
include $(LOCAL_PATH)/ConfigureMe.mk

# Build all lttng modules
all_modules: lttng-modules lttng-tools

# Clean all lttng modules
clean:lttng-modules-clean

lttng-modules: 
	echo "lttng-modules started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) default && \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules_install  INSTALL_MOD_PATH=$(TARGET_OUT) && \
	echo "lttng-modules finished";

lttng-tools:
	echo "lttng-tools started"; \
	cd lttng-tools; \
	./bootstrap; \
	./configure; \
	make LOCAL_CLFAGS += -DLIBXML_SCHEMAS_ENABLED; \
	make install; \
	sudo ldconfig; \
	cd -; \
	echo "lttng-tools finished";
	
lttng-modules-clean:
	echo "lttng-modules-clean started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) clean && \
	echo "lttng-modules-clean finished";
