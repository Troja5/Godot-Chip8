import sys

def main():
    args = sys.argv
    if len(args) != 2:
        print("Invalid number of arguments! Please try again.")
        exit(1)

    path = args[1]
    file = open(path, "rb")
    dump = open(path + "_hexdump.txt", "w")

    bytes = file.read(-1)

    for i, byte in enumerate(bytes):
        if (i % 8) == 0:
            dump.write("\n")
        elif (i % 4) == 0:
            dump.write(" ")
        
        dump.write("{:02X} ".format(byte))

    file.close()
    dump.close()

if __name__ == "__main__":
    main()



