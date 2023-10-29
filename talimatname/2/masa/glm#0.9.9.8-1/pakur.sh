mkdir -p "${PKG}"/usr/include/
cp -r glm "${PKG}"/usr/include/

# For some stupid reason, glm upstream removed the CMake install target here:
# https://github.com/g-truc/glm/commit/5f352ecce21bb1ab37fa56fac0f383c779b351a3
# There is no reasoning for it. Discussion here: https://github.com/g-truc/glm/issues/947
mkdir -p "${PKG}"/usr/lib/pkgconfig/
sed "s/@VERSION@/${surum}/" "${SRC}"/glm.pc.in > "${PKG}"/usr/lib/pkgconfig/glm.pc

mkdir -p "${PKG}"/usr/lib/cmake/glm/
sed "s/@VERSION@/${surum}/" "${SRC}"/glmConfigVersion.cmake.in > "${PKG}"/usr/lib/cmake/glm/glmConfigVersion.cmake
sed "s/@VERSION@/${surum}/" "${SRC}"/glmConfig.cmake.in > "${PKG}"/usr/lib/cmake/glm/glmConfig.cmake
install -Dm644 "${SRC}"/glmTargets.cmake "${PKG}"/usr/lib/cmake/glm/glmTargets.cmake
