package elf;

import elf.dataContainers.ELFData;
import elf.dataContainers.sections.CommandProperties;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class ELF {

    public static ELFData parse(String inFileName) throws IOException {
        return new ELFParser(new FileSourse(inFileName)).parse();
    }

    private static class ELFParser {
        private final FileSourse sourse;
        private ELFData parsedData;

        public ELFParser(FileSourse sourse) {
            this.sourse = sourse;
            parsedData = new ELFData();
        }

        public ELFData parse() throws IOException {
            parseELFHeader();
            parseSectionsHeader();
            parseSymtabSection();
            parseTextSection();
            return parsedData;
        }

        private void parseELFHeader() throws IOException {

            //Parse the file signature (expect ELF)

            StringBuilder eiMagic = new StringBuilder();
            for (int i = 0; i < 4; i++) {
                eiMagic.append(getHex());
                eiMagic.append(" ");
            }

            eiMagic.deleteCharAt(eiMagic.length() - 1);
            if (eiMagic.toString().equals("7f 45 4c 46")) {
                parsedData.headerData.addEIdentData("EI_MAG", eiMagic.toString());
            } else {
                throw new AssertionError("It's not the ELF file");
            }

            //Parse the binary architecture

            String eiClass = getHex();
            if (eiClass.equals("01")) {
                parsedData.headerData.addEIdentData("EI_CLASS", "ELFCLASS32");
            } else {
                throw new AssertionError("Can handle only 32 bit file");
            }

            //Parse the data encoding method

            String eiData = getHex();
            if (eiData.equals("01")) {
                parsedData.headerData.addEIdentData("EI_DATA", "Little Endian");
            } else if (eiData.equals("02")) {
                parsedData.headerData.addEIdentData("EI_DATA", "Big Endian");
            } else {
                parsedData.headerData.addEIdentData("EI_DATA", "Unknown value");
            }

            //Parse the ELF version

            String eiVersion = getHex();
            parsedData.headerData.addEIdentData("EI_VERSION", eiVersion + " (current)");

            //Parse the OS/ABI

            String eiOS = getHex();
            parsedData.headerData.addEIdentData("EI_OSABI", eiOS);

            //Parse the ABI version

            String eiABIVersion = getHex();
            parsedData.headerData.addEIdentData("EI_ABIVERSION", eiABIVersion);

            //Skip reserved items

            skipData(7);
            skipData(2);
            skipData(2);
            skipData(4);
            skipData(4);
            skipData(4);

            //Parse the offset of the section header table

            String eShoff = Integer.toString(getInt(4));
            parsedData.headerData.addSingleParts("E_SHOFF", eShoff);

            // skipData

            skipData(4);
            skipData(2);
            skipData(2);
            skipData(2);

            //Parse the size of one section

            String eShentsize = Integer.toString(getInt(2));
            parsedData.headerData.addSingleParts("E_SHENTSIZE", eShentsize);

            //Parse the number of headers per section

            String eShnum = Integer.toString(getInt(2));
            parsedData.headerData.addSingleParts("E_SHNUM", eShnum);

            //Parse the index of the section with headers

            String eShstrndx = Integer.toString(getInt(2));
            parsedData.headerData.addSingleParts("E_SHSTRNDX", eShstrndx);
        }

        private void parseSectionsHeader() throws IOException {
            //Set cursor to the beginning of section header

            int indexBeginningSectionHeader = Integer.parseInt(parsedData.headerData.getSingleParts("E_SHOFF"));
            sourse.setCursor(indexBeginningSectionHeader);

            //Parse row offset of each section

            int countSections = Integer.parseInt(parsedData.headerData.getSingleParts("E_SHNUM"));
            int[] offestNamesSections = new int[countSections];
            int sizeOneSectionHeader = Integer.parseInt(parsedData.headerData.getSingleParts("E_SHENTSIZE"));
            for (int i = 0; i < countSections; i++) {
                offestNamesSections[i] = getInt(4);
                skipData(sizeOneSectionHeader - 4);
            }

            //Set cursor to the section with sections names

            int numSectionWithNames = Integer.parseInt(parsedData.headerData.getSingleParts("E_SHSTRNDX"));
            sourse.setCursor(indexBeginningSectionHeader + (numSectionWithNames) * sizeOneSectionHeader);

            //Parse the data of section with names

            skipData(4);
            skipData(4);
            skipData(4);
            skipData(4);

            int offsetSectionWithNames = getInt(4);
            //Parse sections names

            String[] sectionsNames = new String[countSections];
            for (int i = 0; i < countSections; i++) {
                sourse.setCursor(offsetSectionWithNames + offestNamesSections[i]);
                StringBuilder name = new StringBuilder();
                char ch = (char) getInt();

                while (ch != (char) 0) {
                    name.append(ch);
                    ch = (char) getInt();
                }

                sectionsNames[i] = name.toString();
            }


            //Parse data every section in sections header

            sourse.setCursor(indexBeginningSectionHeader);
            for (int i = 0; i < countSections; i++) {
                skipData(4);

                String shName = sectionsNames[i];
                String shType = getHex(4);
                String shFlag = getHex(4);
                String shAddr = getHex(4);
                String shOffset = Integer.toString(getInt(4));
                String shSize = Integer.toString(getInt(4));
                String shLink = Integer.toString(getInt(4));
                String shInfo = Integer.toString(getInt(4));
                String shAddralign = Integer.toString(getInt(4));
                String shEntsize = Integer.toString(getInt(4));

                parsedData.sectionsData.addSectoin(shName, shType, shFlag, shAddr, shOffset, shSize, shLink, shInfo, shAddralign, shEntsize);
            }
        }

        private void parseSymtabSection() throws IOException {
            //Set cursor to the begging of string table section

            int entsizeSymTab = Integer.parseInt(parsedData.sectionsData.getSection(".symtab").getSectionProperty("SH_ENTSIZE"));

            //Parse symtable data

            int offsetStrTab = Integer.parseInt(parsedData.sectionsData.getSection(".strtab").getSectionProperty("SH_OFFSET"));
            int offsetSymTab = Integer.parseInt(parsedData.sectionsData.getSection(".symtab").getSectionProperty("SH_OFFSET"));
            int sizeSymTab = Integer.parseInt(parsedData.sectionsData.getSection(".symtab").getSectionProperty("SH_SIZE"));

            sourse.setCursor(offsetSymTab);
            for (int i = 0; i < sizeSymTab / entsizeSymTab; i++) {
                int indexName = getInt(4);
                String stValue = getHex(4);
                String stSize = Integer.toString(getInt(4));
                int info = getInt();
                String stBind = String.valueOf(info >> 4);
                String stType = String.valueOf(info & 0xf);
                String stOther = String.valueOf(getInt() & 0x3);
                String stShndx = getHex(2);

                int prevPos = sourse.getCurPos();
                sourse.setCursor(offsetStrTab + indexName);
                StringBuilder stName = new StringBuilder();
                char el = (char) getInt();

                while (el != (char) 0) {
                    stName.append(el);
                    el = (char) getInt();
                }

                parsedData.sectionsData.addSymbol(
                        stName.toString(), stValue, stSize, stBind, stType, stOther, stShndx
                );

                sourse.setCursor(prevPos);
            }
        }

        private void parseTextSection() throws IOException {
            //Set cursor to the beginning of text section

            int offsetText = Integer.parseInt(parsedData.sectionsData.getSection(".text").getSectionProperty("SH_OFFSET"));
            sourse.setCursor(offsetText);

            //Parse text

            List<Integer> offsets = new LinkedList<>();
            List<Integer> addrs = new LinkedList<>();
            int sizeText = Integer.parseInt(parsedData.sectionsData.getSection(".text").getSectionProperty("SH_SIZE"));
            int addr = Integer.parseInt(parsedData.sectionsData.getSection(".text").getSectionProperty("SH_ADDR"), 16);
            while (sourse.getCurPos() < offsetText + sizeText) {
                int prevPos = sourse.getCurPos();
                String command = Long.toString(Long.parseLong(getHex(4), 16), 2);
                command = "0".repeat(32 - command.length()) + command;
                if (command.substring(30).equals("11")) {
                    int offset = handleFourByteCommand(command, addr);
                    offsets.add(offset);
                    addrs.add(addr);
                    addr += 4;
                } else {
                    sourse.setCursor(prevPos);
                    command = Long.toString(Long.parseLong(getHex(2), 16), 2);
                    command = "0".repeat(16 - command.length()) + command;
                    int offset = handleTwoByteCommand(command, addr);
                    offsets.add(offset);
                    addrs.add(addr);
                    addr += 2;
                }
            }
        }

        private int handleFourByteCommand(String command, int addr) {
            //Parse RV32I + RV32M

            String opcode = command.substring(25, 32);
            String funct3 = command.substring(17, 20);
            String funct7 = command.substring(0, 7);
            String name = "Unknown command";

            switch (opcode) {
                case "0110111" -> uTypeHandler("lui", command, "s", addr);      //lui rd,imm
                case "0010111" -> uTypeHandler("auipc", command, "s", addr);    //auipc rd,imm
                case "1101111" -> {
                    //jal rd,offset

                    String strOffset = getStringByIndexes(command, 0, 0, 12, 19, 11, 11, 1, 10) + "0";
                    int offset = handleNum(strOffset, "s");
                    String rd = getRegName(Integer.parseInt(command.substring(20, 25), 2));

                    String out = "jal " + rd + ", " + offset;

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return offset;  //TODO Offset
                }
                case "1100111" -> {
                    //jalr rd,rs1,offset

                    String strOffset = getStringByIndexes(command, 0, 11);
                    int offset = handleNum(strOffset, "s");
                    String rd = getRegName(Integer.parseInt(command.substring(20, 25), 2));
                    String rs1 = getRegName(Integer.parseInt(command.substring(12, 17), 2));

                    String out = "jalr " + rd + ", " + rs1 + ", " + offset;

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return offset;
                    //TODO Offset
                }
                case "1100011" -> {
                    switch (funct3) {
                        case "000" -> name = "beq";     //beq rs1,rs2,offset
                        case "001" -> name = "bne";     //bne rs1,rs2,offset
                        case "100" -> name = "blt";     //blt rs1,rs2,offset
                        case "101" -> name = "bge";     //bge rs1,rs2,offset
                        case "110" -> name = "bltu";    //bltu rs1,rs2,offset
                        case "111" -> name = "bgeu";    //bgeu rs1,rs2,offset
                    }

                    String strOffset = getStringByIndexes(command, 0, 0, 24, 24, 1, 6, 20, 23) + "0";
                    int offset = handleNum(strOffset, "s");
                    String rs1 = getRegName(Integer.parseInt(command.substring(12, 17), 2));
                    String rs2 = getRegName(Integer.parseInt(command.substring(7, 12), 2));

                    String out = name + " " + rs1 + ", " + rs2 + ", " + offset;

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return offset;
                    //TODO Offset
                }
                case "0000011" -> {
                    switch (funct3) {
                        case "000" -> name = "lb";      //lb rd,offset(rs1)
                        case "001" -> name = "lh";      //lh rd,offset(rs1)
                        case "010" -> name = "lw";      //lw rd,offset(rs1)
                        case "100" -> name = "lbu";     //lbu rd,offset(rs1)
                        case "101" -> name = "lhu";     //lhu rd,offset(rs1)
                    }

                    String strOffset = getStringByIndexes(command, 0, 11);
                    int offset = handleNum(strOffset, "s");
                    String rd = getRegName(Integer.parseInt(command.substring(20, 25), 2));
                    String rs1 = getRegName(Integer.parseInt(command.substring(12, 17), 2));

                    String out = name + " " + rd + ", " + offset + "(" + rs1 + ")";

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return 0;
                }
                case "0100011" -> {
                    switch (funct3) {
                        case "000" -> name = "sb";      //sb rs2,offset(rs1)
                        case "001" -> name = "sh";      //sh rs2,offset(rs1)
                        case "010" -> name = "sw";      //sw rs2,offset(rs1)
                    }

                    String strOffset = getStringByIndexes(command, 0, 6, 20, 24);
                    int offset = handleNum(strOffset, "s");
                    String rs1 = getRegName(Integer.parseInt(command.substring(12, 17), 2));
                    String rs2 = getRegName(Integer.parseInt(command.substring(7, 12), 2));

                    String out = name + " " + rs2 + ", " + offset + "(" + rs1 + ")";

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return 0;
                }
                case "0010011" -> {
                    switch (funct3) {
                        case "000" -> name = "addi";    //addi rd,rs1,imm
                        case "010" -> name = "slti";    //slti rd,rs1,imm
                        case "011" -> name = "sltiu";   //sltiu rd,rs1,imm
                        case "100" -> name = "xori";    //xori rd,rs1,imm
                        case "110" -> name = "ori";     //ori rd,rs1,imm
                        case "111" -> name = "andi";    //andi rd,rs1,imm
                        case "001" -> {
                            switch (funct7) {
                                case "0000000" -> name = "slli";    //slli rd,rs1,rs2
                            }
                            rTypeHandler(name, command, addr);
                            return 0;
                        }
                        case "101" -> {
                            switch (funct7) {
                                case "0000000" -> name = "srli";    //srli rd,rs1,rs2
                                case "0100000" -> name = "srai";    //srai rd,rs1,rs2
                            }
                            rTypeHandler(name, command, addr);
                            return 0;
                        }
                    }

                    iTypeHandler(name, command, "s", addr);
                }
                case "0110011" -> {
                    switch (funct3) {
                        case "000" -> {
                            switch (funct7) {
                                case "0000000" -> name = "add";     //add rd,rs1,rs2
                                case "0100000" -> name = "sub";     //sub rd,rs1,rs2
                                case "0000001" -> name = "mul";     //mul rd,rs1,rs2
                            }
                        }
                        case "001" -> {
                            switch (funct7) {
                                case "0000000" -> name = "sll";     //sll rd,rs1,rs2
                                case "0000001" -> name = "mulh";    //mulh rd,rs1,rs2
                            }
                        }
                        case "010" -> {
                            switch (funct7) {
                                case "0000000" -> name = "slt";     //slt rd,rs1,rs2
                                case "0000001" -> name = "mulhsu";  //mulhsu rd,rs1,rs2
                            }
                        }
                        case "011" -> {
                            switch (funct7) {
                                case "0000000" -> name = "sltu";    //sltu rd,rs1,rs2
                                case "0000001" -> name = "mulhu";   //mulhu rd,rs1,rs2
                            }
                        }
                        case "100" -> {
                            switch (funct7) {
                                case "0000000" -> name = "xor";     //xor rd,rs1,rs2
                                case "0000001" -> name = "div";     //div rd,rs1,rs2
                            }
                        }
                        case "101" -> {
                            switch (funct7) {
                                case "0000000" -> name = "srl";     //srl rd,rs1,rs2
                                case "0100000" -> name = "sra";     //sra rd,rs1,rs2
                                case "0000001" -> name = "divu";    //divu rd,rs1,rs2
                            }
                        }
                        case "110" -> {
                            switch (funct7) {
                                case "0000000" -> name = "or";      //or rd,rs1,rs2
                                case "0000001" -> name = "rem";     //and rd,rs1,rs2
                            }
                        }
                        case "111" -> {
                            switch (funct7) {
                                case "0000000" -> name = "and";     //and rd,rs1,rs2
                                case "0000001" -> name = "remu";    //remu rd,rs1,rs2
                            }
                        }
                    }

                    rTypeHandler(name, command, addr);
                    return 0;
                }
                case "1110011" -> {
                    switch (funct3) {
                        case "001" -> name = "csrrw";       //csrrw rd,offset,rs1
                        case "010" -> name = "csrrs";       //csrrs rd,offset,rs1
                        case "011" -> name = "csrrc";       //csrrc rd,offset,rs1
                        case "101" -> name = "csrrwi";      //csrrwi rd,offset,rs1
                        case "110" -> name = "csrrsi";      //csrrsi rd,offset,rs1
                        case "111" -> name = "csrrci";      //csrrci rd,offset,rs1
                        case "000" -> {
                            if (command.substring(0, 25).equals("0".repeat(25))) {
                                parsedData.sectionsData.addCommand(new CommandProperties(             //ecall
                                        "ecall", Integer.toHexString(addr)
                                ));
                                return 0;
                            } else if (
                                    command.substring(0, 11).equals("0".repeat(11))
                                            && command.charAt(11) == '1'
                                            && command.substring(12, 25).equals("0".repeat(13))
                            ) {
                                parsedData.sectionsData.addCommand(new CommandProperties(
                                        "ebreak", Integer.toHexString(addr)              //ebreak
                                ));
                                return 0;
                            }
                        }
                    }

                    String strOffset = getStringByIndexes(command, 0, 11);
                    int offset = handleNum(strOffset, "s");
                    String rd = getRegName(Integer.parseInt(
                            getStringByIndexes(command, 20, 24), 2
                    ));
                    String rs1 = getRegName(Integer.parseInt(
                            getStringByIndexes(command, 12, 16), 2
                    ));

                    String out = name + " " + rd + ", " + offset + ", " + rs1;

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return 0;
                }

                default -> parsedData.sectionsData.addCommand(new CommandProperties(
                        name, Integer.toHexString(addr)
                ));
            }
            return 0;
        }

        private int handleTwoByteCommand(String twoCommand, int addr) {
            //Parse RV32C

            String command = twoCommand;
            if (command.equals("1001000000000010")) {
                //c.ebreak

                String out = "c.ebreak";

                parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                return 0;
            }
            switch (command.substring(0, 6)) {
                case "10011" -> {
                    if (command.substring(9, 11).equals("00") && command.substring(14).equals("01")) {
                        //c.sub rd,rs1

                        String rd = getShortRegName(Integer.parseInt(getStringByIndexes(command, 6, 8), 2));
                        String rs1 = getShortRegName(Integer.parseInt(getStringByIndexes(command,11,13), 2));

                        String out = "c.sub " + rd + ", " + rs1;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(9, 11).equals("01") && command.substring(14).equals("01")) {
                        //c.xor rd,rs1

                        String rd = getShortRegName(Integer.parseInt(getStringByIndexes(command, 6, 8), 2));
                        String rs1 = getShortRegName(Integer.parseInt(getStringByIndexes(command,11,13), 2));

                        String out = "c.xor " + rd + ", " + rs1;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(9, 11).equals("10") && command.substring(14).equals("01")) {
                        //c.or rd,rs1

                        String rd = getShortRegName(Integer.parseInt(getStringByIndexes(command, 6, 8), 2));
                        String rs1 = getShortRegName(Integer.parseInt(getStringByIndexes(command,11,13), 2));

                        String out = "c.or " + rd + ", " + rs1;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(9, 11).equals("11") && command.substring(14).equals("01")) {
                        //c.and rd,rs1

                        String rd = getShortRegName(Integer.parseInt(getStringByIndexes(command, 6, 8), 2));
                        String rs1 = getShortRegName(Integer.parseInt(getStringByIndexes(command,11,13), 2));

                        String out = "c.and " + rd + ", " + rs1;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
            }

            switch (command.substring(0, 3)) {
                case "110" -> {
                    if (command.substring(14).equals("01")) {
                        //c.beqz rs1,offset

                        String rs1 = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));
                        String strOffset = getStringByIndexes(command, 3, 3, 9, 10, 13, 13, 4, 5, 11, 12);
                        int offset = handleNum(strOffset, "s");

                        String out = "c.beqz " + rs1 + ", " + offset;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(14).equals("00")) {
                        //c.sw rd,uimm(rs1)

                        String strUimm = getStringByIndexes(command, 10, 10, 3, 5, 9, 9);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(getStringByIndexes(command, 11, 13), 2));
                        String rs1 = getShortRegName(Integer.parseInt(getStringByIndexes(command, 6, 8), 2));

                        String out = "c.sw " + rd + ", " +  uImm + "(" + rs1 + ")";

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(14).equals("10")) {
                        //c.swsp rs2,uimm(sp)

                        String strUimm = getStringByIndexes(command, 7, 8, 3, 6);
                        int uImm = handleNum(strUimm, "u");
                        String rs2 = getShortRegName(Integer.parseInt(command.substring(11, 14), 2));

                        String out = "c.swsp " + rs2 + ", " + uImm + "(sp)";

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
                case "011" -> {
                    if (command.substring(14).equals("01") && command.substring(4, 9).equals("00010")) {
                        //c.addi16sp

                        String strImm = getStringByIndexes(command,
                                3, 10
                                );
                        int imm = handleNum(strImm, "s");

                        String out = "c.addi16sp " + "sp" + ", " + "sp" + ", " + imm;
                        return 0;
                    }
                    else if (command.substring(14).equals("01")){
                        //c.lui rd,uimm

                        String strImm = getStringByIndexes(command, 3, 3, 9, 13);
                        int imm = handleNum(strImm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "c.lui " + rd + ", " + Integer.toString(imm);

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(14).equals("00")) {
                        //c.flw rd,uimm(rs1)

                        String strUimm = getStringByIndexes(command, 10, 10, 3, 5, 9, 9);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(11, 14), 2));
                        String rs1 = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));

                        String out = "c.flw c" + rd + ", " + uImm + "(" + rs1 + ")";

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
                case "001" -> {
                    //c.jal offset

                    String strOffset = getStringByIndexes(
                            command, 3, 3, 7, 7, 5, 6, 9, 9, 8, 8, 13, 13, 4, 4, 10, 12
                    );

                    int offset = handleNum(strOffset, "s");

                    String out = "c.jal" + strOffset;

                    parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                    return offset;

                    //TODO Offset
                }
                case "100" -> {
                    if (command.charAt(3) == '1' && command.substring(9, 14).equals("00000") && command.substring(14).equals("10")) {
                        //c.jalr rd

                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "jalr " + rd;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.charAt(3) == '0' && command.substring(9, 14).equals("00000") && command.substring(14).equals("10")) {
                        //c.jr rs1

                        String rs1 = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "c.jr " + rs1;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.charAt(3) == '0' && command.substring(14).equals("10")) {
                        //c.mv rd,rs2

                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));
                        String rs2 = getShortRegName(Integer.parseInt(command.substring(9, 14), 2));

                        String out = "c.mv " + rd + ", " + rs2;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(4, 6).equals("10") && command.substring(14).equals("10")) {
                        //c.andi rd,uimm

                        String strUimm = command.substring(3, 4) + command.substring(9, 14);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));

                        String out = "c.andi " + rd + ", " + uImm;
                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(4, 6).equals("00") && command.substring(14).equals("01")) {
                        //c.srli rd,uimm

                        String strUimm = command.substring(3, 4) + command.substring(9, 14);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));

                        String out = "c.srli " + rd + ", " + uImm;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(4, 6).equals("01") && command.substring(14).equals("01")) {
                        //c.srai rd,uimm

                        String strUimm = command.substring(3, 4) + command.substring(9, 14);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));

                        String out = "c.srai " + rd + ", " + uImm;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.charAt(3) == '1' && command.substring(14).equals("10")) {
                        //c.add rd,rs2

                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));
                        String rs1 = getShortRegName(Integer.parseInt(command.substring(9, 14), 2));

                        String out = "c.add " + rd + ", " + rs1;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
                case "010" -> {
                    if (command.substring(14).equals("00")) {
                        //c.lw rd,uimm(rs1)

                        String strUimm = command.substring(10, 11) + command.substring(3, 6) + command.substring(9, 10);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(11, 14), 2));
                        String rs1 = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));

                        String out = "c.lw " + rd + ", " + uImm + "(" + rs1 + ")";

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(14).equals("01")) {
                        //c.li rd,uimm

                        String strUimm = getStringByIndexes(command, 3, 3, 9, 13);
                        int uInmm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "c.li " + rd + ", " + uInmm;
                        return 0;
                    } else if (command.substring(14).equals("10")) {
                        //c.fswsp rd,uimm(x2)

                        String strUimm = command.substring(12, 14) + command.substring(3, 4)
                                + command.substring(9, 12) + "00";
                        int uimm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "c.lwsp " + rd + ", " + uimm + "(sp)";

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
                case "000" -> {
                    if (command.substring(0, 15).equals("0".repeat(15)) && command.charAt(15) == '1') {
                        //c.nop

                        String out = "c.nop";

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                    else if (command.substring(14).equals("01")) {
                        //c.addi4spn rd,u[12:12]|u[6:2]

                        String strImm = command.substring(3, 4) + command.substring(9, 14);
                        int imm = handleNum(strImm, "s");
                        String rd = getRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "c.addi " + rd + ", " + imm;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(14).equals("00")) {
                        //c.addi4spn rd,rd,uimm

                        String strUimm = command.substring(3, 11);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(11, 14), 2));

                        String out = "c.addi4spn " + rd + ", " + rd + ", " + uImm;
                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    } else if (command.substring(14).equals("10")) {
                        //c.slli rd,uimm

                        String strUimm = command.substring(3, 4) + command.substring(9, 14);
                        int uImm = handleNum(strUimm, "u");
                        String rd = getShortRegName(Integer.parseInt(command.substring(4, 9), 2));

                        String out = "c.slli " + rd + ", " + uImm;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
                case "101" -> {
                    if (command.substring(14).equals("01")) {
                        //c.j offset

                        String strOffset = command.substring(3, 4) + command.substring(7, 8)
                                + command.substring(5, 7) + command.substring(9, 10)
                                + command.substring(8, 9) + command.substring(13, 14)
                                + command.substring(4, 5) + command.substring(10, 13) + "0";
                        int offset = handleNum(strOffset, "s");

                        String out  = "c.j " + offset;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
                case "111" -> {
                    if (command.substring(14).equals("01")) {
                        //c.bnez rs1,offset

                        String strOffset = command.substring(3, 4) + command.substring(9, 11)
                                + command.substring(13, 14) + command.substring(4, 6)
                                + command.substring(11, 13) + "0";
                        int offset = handleNum(strOffset, "s");
                        String rs1 = getShortRegName(Integer.parseInt(command.substring(6, 9), 2));

                        String out = "c.bnez " + rs1 + ", " + offset;

                        parsedData.sectionsData.addCommand(new CommandProperties(out, Integer.toHexString(addr)));
                        return 0;
                    }
                }
            }

            parsedData.sectionsData.addCommand(new CommandProperties("Unknown comand", Integer.toHexString(addr)));
            return 0;
        }

        private void uTypeHandler(String name, String command, String typeImm, int addr) {
            String strImm = getStringByIndexes(command, 0, 19) + "0".repeat(12);
            int imm = handleNum(strImm, typeImm);

            String rd = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 20, 24), 2)
            );

            String out = name + ' ' + rd + ',' + imm;

            parsedData.sectionsData.addCommand(new CommandProperties(
                    out, Integer.toHexString(addr)
            ));
        }

        private void rTypeHandler(String name, String command, int addr) {
            String rd = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 20, 24), 2)
            );

            String rs1 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 12, 16), 2)
            );

            String rs2 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 7, 11), 2)
            );

            String out = name + ' ' + rd + ',' + rs1 + ',' + rs2;

            parsedData.sectionsData.addCommand(new CommandProperties(
                    out, Integer.toHexString(addr)
            ));
        }

        private void iTypeHandler(String name, String command, String typeImm, int addr) {
            String strImm = getStringByIndexes(command, 0, 11);
            int imm = handleNum(strImm, typeImm);

            String rd = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 20, 24), 2)
            );

            String rs1 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 12, 16), 2)
            );

            String out = name + ' ' + rd + ',' + rs1 + ',' + imm;

            parsedData.sectionsData.addCommand(new CommandProperties(
                    out, Integer.toHexString(addr)
            ));
        }

        private void sTypeHandler(String name, String command, String typeImm, int addr) {
            String strImm = getStringByIndexes(command, 0, 6, 20, 24);
            int imm = handleNum(strImm, typeImm);

            String rs1 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 12, 16), 2)
            );

            String rs2 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 7, 11), 2)
            );

            String out = name + ' ' + rs2 + ',' + imm + '(' + rs1 + ')';

            parsedData.sectionsData.addCommand(new CommandProperties(
                    out, Integer.toHexString(addr)
            ));
        }

        private void bTypeHandler(String name, String command, String typeImm, int addr) {
            String strImm = getStringByIndexes(command, 0, 0, 24, 24, 1, 6, 20, 23) + "0";
            int imm = handleNum(strImm, typeImm);

            String rs1 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 12, 16), 2)
            );

            String rs2 = getRegName(
                    Integer.parseInt(getStringByIndexes(command, 7, 11), 2)
            );

            String out = name + ' ' + rs1 + ',' + rs2 + ',' + imm;

            parsedData.sectionsData.addCommand(new CommandProperties(
                    out, Integer.toHexString(addr)
            ));
        }

        private void jTypeHandler(String name, String command, String typeImm, int addr) {
            String strImm = getStringByIndexes(command, 20, 20, 12, 19, 11, 11, 1, 10) + "0";
            int imm = handleNum(strImm, typeImm);
            String rd = getRegName(
                    Integer.parseInt(getStringByIndexes(command,20, 24), 2)
            );

            String out = name + ' ' + rd + ',' + imm;

            parsedData.sectionsData.addCommand(new CommandProperties(
                    out, Integer.toHexString(addr)
            ));
        }

        private int handleNum(String strNum, String typeNum) {
            switch (typeNum) {
                case "s" -> {
                    int imm = Integer.parseInt(strNum.substring(1), 2);
                    if (strNum.charAt(0) == '1') {
                        imm -= (int) Math.pow(2, strNum.length() - 1);
                    }
                    return imm;
                }
                case "u" -> {
                    return Integer.parseInt(strNum, 2);
                }
                default -> throw new AssertionError("Unknown typeNum" + typeNum);
            }
        }

        private String getStringByIndexes(String command, int ...indexes) {
            StringBuilder res = new StringBuilder();
            for (int i = 0; i < indexes.length; i += 2) {
                int f = indexes[i];
                int s = indexes[i + 1];
                while (f <= s) {
                    res.append(command.charAt(f));
                    f += 1;
                }
            }

            return res.toString();
        }

        private String getRegName(int index) {
            return switch (index) {
                case 0 -> "zero";
                case 1 -> "ra";
                case 2 -> "sp";
                case 3 -> "gp";
                case 4 -> "tp";
                case 5 -> "t0";
                case 6 -> "t1";
                case 7 -> "t2";
                case 8 -> "s0";
                case 9 -> "s1";
                case 10 -> "a0";
                case 11 -> "a1";
                case 12 -> "a2";
                case 13 -> "a3";
                case 14 -> "a4";
                case 15 -> "a5";
                case 16 -> "a6";
                case 17 -> "a7";
                case 18 -> "s2";
                case 19 -> "s3";
                case 20 -> "s4";
                case 21 -> "s5";
                case 22 -> "s6";
                case 23 -> "s7";
                case 24 -> "s8";
                case 25 -> "s9";
                case 26 -> "s10";
                case 27 -> "s11";
                case 28 -> "t3";
                case 29 -> "t4";
                case 30 -> "t5";
                case 31 -> "t6";
                default -> throw new AssertionError(String.format("Index %d doesn't exist", index));
            };
        }

        private String getShortRegName(int index) {
            Map<Integer, String> shortRegName = Map.of(
                    0, "s0",
                    1, "s1",
                    2, "a0",
                    3, "a1",
                    4, "a2",
                    5, "a3",
                    6, "a4",
                    7, "a5"
            );
            if (index >= shortRegName.size()) {
                return getRegName(index);
            }
            return shortRegName.get(index);
        }

        private String getHex() throws IOException {
            String res = Integer.toHexString(sourse.read());
            return res.length() == 1 ? "0" + res : res;
        }

        private String getHex(int n) throws IOException {
            String res = Integer.toHexString(sourse.read(n));
            return res.length() == 1 ? "0" + res : res;
        }

        private int getInt() throws IOException {
            return sourse.read();
        }

        private int getInt(int n) throws IOException {
            return sourse.read(n);
        }

        private void skipData(int n) throws IOException {
            sourse.setCursor(sourse.getCurPos() + n);
        }

    }
}
