# Single Cycle 32bits RISC-V CPU Tutorial

Let's make a CPU core using RISC-V !

For starters, we will start with a very simple simple cycle cpu, as it is the best begginer-friendly project to get started !

## Tools stack used for the project

### The HDL

SystemVerilog

### Simulator :  Verilator

[docs](https://verilator.org/guide/latest/index.html)

```sudo apt install verilator```

On [debian 11 and other versions](https://repology.org/project/verilator/versions), the apt packages may not fot the versions requirements for cocotb. you can choose to use another simulator, or like me, use this **VERY CONVINIENT** (not) set of commands to build from git :

```bash
sudo apt install git make autoconf g++ flex bison help2man
git clone https://github.com/verilator/verilator.git
cd verilator
git checkout stable
autoconf
./configure
make -j$(nproc)
sudo make install
verilator --version
```

### TenstBenches : cocotb

[WebSite](https://www.cocotb.org/)

[docs](https://docs.cocotb.org/en/stable/install.html)

```sudo apt-get install make python3 python3-pip libpython3-dev```

```pip install cocotb```

for the "makefile" : [docs](https://docs.cocotb.org/en/stable/quickstart.html#creating-a-makefile)