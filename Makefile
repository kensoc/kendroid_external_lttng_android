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
clean:lttng-modules-clean lttng-tools-clean

lttng-modules: 
	echo "lttng-modules build started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) default && \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules_install  INSTALL_MOD_PATH=$(ANDROID_ROOT)/$(TARGET_OUT) && \
	echo "lttng-modules build finished";

lttng-modules-clean:
	echo "lttng-modules-clean started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) clean && \
	echo "lttng-modules-clean finished";

userspace-rcu:
	echo "userspace-rcu build started"; \
	cd $(LOCAL_PATH)/../userspace-rcu; \
	./bootstrap; \
	./configure --host=$(HOST_MACH) --target=$(TARGET_MACH) --prefix=$(ANDROID_ROOT)/$(TARGET_OUT) && \
	make && \
	make install && \
	ldconfig; \
	cd -; \
	echo "userspace-rcu build  finished"

userspace-rcu-clean:
	echo "userspace-rcu-clean started" \
	cd $(LOCAL_PATH)/../userspace-rcu; \
	make clean; \
	cd -; \
	echo "userspace-rcu-clean finished"

libxml2:
	echo "libxml2 build started"; \
	cd $(LOCAL_PATH)/../libxml2; \
	autoreconf -i; \
	./configure --without-lzma --enable-shared --enable-static --host=$(HOST_MACH) --target=$(TARGET_MACH) --prefix=$(ANDROID_ROOT)/$(TARGET_OUT); \
	make libxml2.la; \
	cp xml2-config $(ANDROID_ROOT)/$(TARGET_OUT_EXECUTABLES); \
	cp libxml2.la $(ANDROID_ROOT)/$(TARGET_OUT_SHARED_LIBRARIES); \
	cp .libs/libxml2.a $(ANDROID_ROOT)/$(TARGET_OUT_SHARED_LIBRARIES); \
	cd .libs; \
	find -name 'libxml2.so*' | cpio -pdm $(ANDROID_ROOT)/$(TARGET_OUT_SHARED_LIBRARIES); \
	cd -; \
	cd -; \
	echo "libxml2 build finished"

libxml2-clean:
	echo "libxml2-clean started"; \
	cd $(LOCAL_PATH)/../libxml2; \
	make clean; \
	cd -; \
	echo "libxml2-clean finished"

lttng-tools:userspace-rcu libxml2
	echo "lttng-tools started"; \
	cd $(LOCAL_PATH)/../lttng-tools; \
	./bootstrap; \
	./configure --host=$(HOST_MACH) --target=$(TARGET_MACH) --prefix=$(ANDROID_ROOT)/$(TARGET_OUT) --program-prefix='' --with-lttng-system-rundir=$(ANDROID_ROOT)/$(TARGET_OUT)/vendor/var/run --with-xml-prefix=$(ANDROID_ROOT)/$(TARGET_OUT); \
	make; \
	make DESTDIR=$(ANDROID_ROOT)/$(TARGET_OUT) install; \
	ldconfig; \
	cd -; \
	echo "lttng-tools finished";

lttng-tools-clean:userspace-rcu-clean libxml2-clean
	echo "lttng-tools-clean started"; \
	cd $(LOCAL_PATH)/../lttng-tools; \
	make clean; \
	cd -; \
	echo "lttng-tools-clean finished"	
