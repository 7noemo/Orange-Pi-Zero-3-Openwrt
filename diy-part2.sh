#!/bin/bash
#
# OpenWrt DIY script part 2 (After Update feeds)
# Based on P3TERX/Actions-OpenWrt
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
#sed -i 's/luci-theme-bootstrap/luci-theme-argonne/g' feeds/luci/collections/luci/Makefile

# Fix sun55i (A523) IOMMU driver for kernel >= 6.18.60
# Linux 6.18 stable backported the mainline change that adds an `old` domain
# parameter to iommu_domain_ops.attach_dev(), which breaks ImmortalWrt's
# out-of-tree sunxi iommu driver (drivers/iommu/sun55i-iommu.c):
#   error: initialization of 'int (*)(struct iommu_domain *, struct device *,
#          struct iommu_domain *)' from incompatible pointer type
# Guarded: auto-skipped once upstream ships the same fix.
IOMMU_C=target/linux/sunxi/files/drivers/iommu/sun55i-iommu.c
if [ -f "$IOMMU_C" ]; then
    if grep -q 'sun55i_iommu_attach_dev(struct iommu_domain \*domain, struct device \*dev)$' "$IOMMU_C"; then
        # Already fixed upstream (single-line signature) - nothing to do
        echo "[fix-iommu] upstream already fixed (single-line signature)"
    elif grep -q 'sun55i_iommu_attach_dev(struct iommu_domain \*domain,$' "$IOMMU_C"; then
        perl -0pi -e 's/static int sun55i_iommu_attach_dev\(struct iommu_domain \*domain,\s*\n\s*struct device \*dev\)/static int sun55i_iommu_attach_dev(struct iommu_domain *domain,\n\t\t\t   struct device *dev,\n\t\t\t   struct iommu_domain *old)/' "$IOMMU_C"
        if grep -q 'sun55i_iommu_attach_dev(struct iommu_domain \*domain,$' "$IOMMU_C" && \
           grep -A1 'sun55i_iommu_attach_dev(struct iommu_domain \*domain,$' "$IOMMU_C" | grep -q 'struct iommu_domain \*old'; then
            echo "[fix-iommu] patched attach_dev with new 'old' domain parameter (kernel 6.18.60+)"
        else
            echo "::error::sun55i-iommu attach_dev patch failed - pattern no longer matches, please update diy-part2.sh"
            exit 1
        fi
    else
        echo "[fix-iommu] attach_dev signature not found in expected form - skipping (upstream may have restructured)"
    fi
else
    echo "[fix-iommu] sun55i-iommu.c not found - skipping (upstream may have moved it)"
fi
