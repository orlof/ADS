
OS_NAME ?=$(shell uname)
VPATH = AdsLib
LIBS = -lpthread
LIB_NAME = AdsLib-$(OS_NAME).a
SHARED_LIB_NAME = obj/AdsLib.so
INSTALL_DIR=../pyads/pyads
CXX :=$(CROSS_COMPILE)$(CXX)
CFLAGS += -std=c++11
CFLAGS += -pedantic
CFLAGS += -Wall
CFLAGS += -fPIC

SRC_DIR := AdsLib
OBJ_DIR := obj

# Automatically collect all .cpp files
CPP_FILES := $(wildcard $(SRC_DIR)/*.cpp)
# Create list of corresponding .obj outputs
OBJ_FILES := $(addprefix $(OBJ_DIR)/,$(notdir $(CPP_FILES:.cpp=.o)))

ifeq ($(OS_NAME),Darwin)
	LIBS += -lc++
endif

ifeq ($(OS_NAME),win32)
	LIBS += -lws2_32
endif

all: $(SHARED_LIB_NAME)

$(OBJ_FILES): $(OBJ_DIR)/%.o: %.cpp
	$(CXX) -c $(CFLAGS) $< -o $@ -I AdsLib/

$(SHARED_LIB_NAME): $(OBJ_FILES)
	$(CXX) -shared -fPIC -o $(SHARED_LIB_NAME) $?

AdsLibTest.bin: AdsLibTest/main.o $(LIB_NAME)
	$(CXX) $^ $(LIBS) -o $@

test: AdsLibTest.bin
	./$<

install: $(SHARED_LIB_NAME)
	cp $? $(INSTALL_DIR)/

clean:
	rm -f *.a *.o *.bin AdsLibTest/*.o obj/*.o obj/*.so

uncrustify:
	uncrustify --no-backup -c tools/uncrustify.cfg AdsLib*/*.h AdsLib*/*.cpp example/*.cpp

prepare-hooks:
	rm -f .git/hooks/pre-commit
	ln -Fv tools/pre-commit.uncrustify .git/hooks/pre-commit
	chmod a+x .git/hooks/pre-commit

.PHONY: clean uncrustify prepare-hooks
