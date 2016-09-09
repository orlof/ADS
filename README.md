# ADS
Fork of the Beckhoff/ADS repo: https://github.com/Beckhoff/ADS

Modified for use with the pyads python wrapper: https://github.com/MrLeeh/pyads

## Usage
```bash
git clone https://github.com/dabrowne/ADS.git

# change into root of the cloned repository
cd ADS

# build the library
make

# copy compiled library to the target location $(INSTALL_DIR) in the Makefile
# NB: You need to manually adjust this to the location of your choosing
make install
```

## Modifications from original repo

 - Adjusted the build process to output Linux shared object (.so)
 - Wrapped API in extern "C" to avoid name mangling