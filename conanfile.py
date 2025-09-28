from conan import ConanFile

class Sql101Recipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = ["CMakeDeps", "CMakeToolchain"]
    
    def requirements(self):
        self.requires("sqlpp11/0.64")
        self.requires("yaml-cpp/0.8.0")
        self.requires("spdlog/1.13.0")
        self.requires("gtest/1.14.0")
    