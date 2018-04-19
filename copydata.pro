TEMPLATE = aux

# Copy all QML files during the build time
DIRECTORIES = apps dev/apps imports sysui styles
FILES = am-config.yaml Main.qml server.conf

for (d , DIRECTORIES) {
    win32: do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/$${d}) $$shell_path($$OUT_PWD/$${d}) $$escape_expand(\n\t)
    else: do_copydata.commands += $(COPY_DIR) $$shell_path($$PWD/$${d}) $$shell_path($$OUT_PWD) $$escape_expand(\n\t)
}
for (f , FILES) {
    do_copydata.commands += $(COPY) $$shell_path($$PWD/$${f}) $$shell_path($$OUT_PWD/$${f}) $$escape_expand(\n\t)
}

first.depends = do_copydata
!equals(PWD, $$OUT_PWD):QMAKE_EXTRA_TARGETS += first do_copydata
