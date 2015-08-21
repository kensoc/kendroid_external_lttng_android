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
#all_modules: lttng-modules lttng-ust lttng-tools
all_modules: lttng-modules lttng-ust

# Clean all lttng modules
#clean:lttng-modules-clean lttng-ust-clean lttng-tools-clean
clean:lttng-modules-clean lttng-ust-clean

#### LTTNG-MODULES
lttng-modules: 
	echo "lttng-modules build started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) default && \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) modules_install  INSTALL_MOD_PATH=$(ANDROID_ROOT)/$(TARGET_OUT) && \
	echo "lttng-modules build finished";

lttng-modules-clean:
	echo "lttng-modules-clean started"; \
	$(MAKE) -C $(LOCAL_PATH)/../lttng-modules $(KERNELDIR) clean && \
	echo "lttng-modules-clean finished";

#### LIBXML2
libxml2:
	echo "libxml2 build started"; \
	cd $(LOCAL_PATH)/../libxml2; \
	autoreconf -i; \
	./configure --without-lzma --enable-shared $(CONFIGURE_OPTIONS); \
	make; \
	make install; \
	cd -; \
	echo "libxml2 build finished"

libxml2-clean:
	echo "libxml2-clean started"; \
	cd $(LOCAL_PATH)/../libxml2; \
	make clean; \
	cd -; \
	echo "libxml2-clean finished"

#### USERSPACE-RCU
userspace-rcu:
	echo "userspace-rcu build started"; \
	cd $(LOCAL_PATH)/../userspace-rcu; \
	./bootstrap; \
	./configure --enable-shared --disable-static $(CONFIGURE_OPTIONS) && \
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

#### LTTNG-UST
lttng-ust: userspace-rcu
	echo "lttng-ust build started"; \
	cd $(LOCAL_PATH)/../lttng-ust; \
	./bootstrap; \
        ./configure --enable-shared --disable-static $(CONFIGURE_OPTIONS) --program-prefix='' --with-lttng-system-rundir=$(ANDROID_ROOT)/$(TARGET_OUT)/vendor/var/run CPPFLAGS=-I$(ANDROID_ROOT)/$(TARGET_OUT)/include LDFLAGS=-L$(ANDROID_ROOT)/$(TARGET_OUT)/lib; \
        make; \
        make DESTDIR=$(ANDROID_ROOT)/$(TARGET_OUT) install; \
        cd -; \
        echo "lttng-ust build finished";

lttng-ust-clean:
	echo "lttng-ust-clean started"; \
	cd $(LOCAL_PATH)/../lttng-ust; \
	make clean; \
	cd -; \
	echo "lttng-ust-clean finished"

#### LTTNG-TOOLS
lttng-tools:libxml2 userspace-rcu lttng-ust
	echo "lttng-tools started"; \
	cd $(LOCAL_PATH)/../lttng-tools; \
	./bootstrap; \
	./configure --enable-shared --disable-static $(CONFIGURE_OPTIONS) --program-prefix='' --with-lttng-system-rundir=$(ANDROID_ROOT)/$(TARGET_OUT)/vendor/var/run --with-xml-prefix=$(ANDROID_ROOT)/$(TARGET_OUT) CPPFLAGS=-I$(ANDROID_ROOT)/$(TARGET_OUT)/include LDFLAGS=-L$(ANDROID_ROOT)/$(TARGET_OUT)/lib --with-lttng-ust-prefix=$(ANDROID_ROOT)/$(TARGET_OUT); \
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
