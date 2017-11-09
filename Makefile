CXX = clang++
INCLUDE = -I./include
SRC_DIR = ./src
OBJ_DIR = ./obj
TARGET = a.out
SRCS = $(shell find $(SRC_DIR) -name "*.cpp")
OBJS = $(subst $(SRC_DIR), $(OBJ_DIR), $(SRCS:.cpp=.o))
DEPENDS = $(OBJS:.o=.d)

CXX_DEBUG_FLAGS = -g -O0
CXX_RELEASE_FLAGS = -O3
CXXFLAGS = -std=c++1z -pthread -MMD -MP

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDE) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@if [ ! -d $(dir $@) ]; then\
		mkdir -p $(dir $@); \
	fi
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

.PHONY: debug
debug: CXXFLAGS += $(CXX_DEBUG_FLAGS)
debug: all

.PHONY: release
release: CXXFLAGS += $(CXX_RELEASE_FLAGS)
release: all

.PHONY: run
run: $(TARGET)
	./$(TARGET)

.PHONY: clean
clean:
	rm -rf $(OBJS) $(DEPENDS) $(OBJ_DIR)/*

-include $(DEPENDS)
