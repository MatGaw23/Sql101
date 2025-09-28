#include <gtest/gtest.h>
#include <spdlog/spdlog.h>

// Basic test to verify the testing framework is working
TEST(BootstrapTest, BasicFunctionality) {
  // Test that basic logging works
  spdlog::info("Running bootstrap test");

  // Basic assertion
  EXPECT_EQ(1 + 1, 2);
  EXPECT_TRUE(true);
}

// Test that the project can be built and linked properly
TEST(BootstrapTest, DependenciesAvailable) {
  // Test spdlog availability
  auto logger = spdlog::get("console");
  // Logger might be null if not initialized, which is fine for this test

  // Test that we can create a basic logger
  auto test_logger = spdlog::default_logger();
  EXPECT_NE(test_logger, nullptr);

  test_logger->info("Dependencies are properly linked!");
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);

  // Initialize logging for tests
  spdlog::set_level(spdlog::level::info);

  return RUN_ALL_TESTS();
}
