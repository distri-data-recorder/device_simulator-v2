# Makefile for Device Simulator — build outputs to ./build
CC      := gcc
CFLAGS  := -Wall -Wextra -O2 -I. -Iprotocol
LDFLAGS := -lm

# Platform flags
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    CFLAGS += -D_GNU_SOURCE
endif

# ===== Build folders =====
BUILD_DIR := build

# ===== Sources & objects =====
# Add more source folders here if needed (e.g., src utils ...)
SRC_DIRS := . protocol
SRCS     := $(foreach d,$(SRC_DIRS),$(wildcard $(d)/*.c))
OBJS     := $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))
DEPS     := $(OBJS:.o=.d)

# ===== Target =====
TARGET := device_simulator
BIN    := $(BUILD_DIR)/$(TARGET)

# ===== Default =====
all: $(BIN)

# Link
$(BIN): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# Compile: place objects and dependency files in build/
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

# Run
run: $(BIN)
	./$(BIN)

# Debug build
debug: CFLAGS += -g -DDEBUG
debug: clean all

# Clean
clean:
	rm -rf $(BUILD_DIR)

# Include auto-generated deps (if they exist)
-include $(DEPS)

.PHONY: all clean run debug
