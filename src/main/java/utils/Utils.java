package utils;

import org.apache.commons.lang3.tuple.MutablePair;
import org.apache.commons.lang3.tuple.Pair;

import java.io.*;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Utils {

    static public String readLineFromConsole(String prompt) {
        try {
            System.out.println("\n" + prompt);

            InputStreamReader converter = new InputStreamReader(System.in);
            BufferedReader in = new BufferedReader(converter);

            return in.readLine();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    static public int readIntegerFromConsole(String prompt) {
        do {
            try {
                String input = readLineFromConsole(prompt);

                int value = Integer.parseInt(input);

                return value;
            } catch (NumberFormatException ex) {
                Logger.getLogger(Utils.class.getName()).log(Level.SEVERE, null, ex);
            }
        } while (true);
    }

    static public double readDoubleFromConsole(String prompt) {
        do {
            try {
                String input = readLineFromConsole(prompt);

                double value = Double.parseDouble(input);

                return value;
            } catch (NumberFormatException ex) {
                Logger.getLogger(Utils.class.getName()).log(Level.SEVERE, null, ex);
            }
        } while (true);
    }
    static public LocalTime readTimeFromConsole(String prompt){
        do {
            try {
                String strTime = readLineFromConsole(prompt);
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");

                LocalTime localTime = LocalTime.parse(strTime, formatter);

                if (validarHora(localTime)) {
                    return localTime;
                } else {
                    System.out.println("Hora inválida. Tente novamente.");
                }
            } catch (Exception ex) {
                System.out.println("Formato de hora inválido. Tente novamente.");
            }
        } while (true);
    }

    static public LocalDate readDateFromConsole(String prompt) {
        do {
            try {
                String strDate = readLineFromConsole(prompt);

                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

                if (validarData(strDate)) {
                    LocalDate localDate = LocalDate.parse(strDate, formatter);

                    return localDate;
                } else {
                    System.out.println("Data inválida. Tente novamente.");
                }
            } catch (Exception ex) {
                System.out.println("Formato de data inválido. Tente novamente.");
            }
        } while (true);
    }

    static public boolean confirm(String message) {
        String input;
        do {
            input = Utils.readLineFromConsole("\n" + message + "\n");
        } while (!input.equalsIgnoreCase("s") && !input.equalsIgnoreCase("n"));

        return input.equalsIgnoreCase("s");
    }

    static public Object showAndSelectOne(List list, String header) {
        showList(list, header);
        return selectsObject(list);
    }

    static public int showAndSelectIndex(List list, String header) {
        showList(list, header);
        return selectsIndex(list);
    }

    static public void showList(List list, String header) {
        System.out.println(header);

        int index = 0;
        for (Object o : list) {
            index++;

            System.out.println(index + ". " + o.toString());
        }
        System.out.println();
        System.out.println("0 - Cancel");
    }

    static public Object selectsObject(List list) {
        String input;
        Integer value;
        do {
            input = Utils.readLineFromConsole("Type your option: ");
            value = Integer.valueOf(input);
        } while (value < 0 || value > list.size());

        if (value == 0) {
            return null;
        } else {
            return list.get(value - 1);
        }
    }

    static public int selectsIndex(List list) {
        String input;
        Integer value;
        do {
            input = Utils.readLineFromConsole("Type your option: ");
            try {
                value = Integer.valueOf(input);
            } catch (NumberFormatException ex) {
                value = -1;
            }
        } while (value < 0 || value > list.size());

        return value - 1;
    }
    static public int diasMes(int ano, int mes){
        if (mes == 4 || mes == 6 || mes == 9 || mes == 11){
            return 30;
        }else if (mes ==2){
            if (ano % 4 == 0) {
                if (ano % 100 == 0) {
                    if (ano % 400 == 0) {
                        return 29;
                    } else {
                        return 28;
                    }
                } else {
                    return 29;
                }
            } else {
                return 28;
            }
        } else {
            return 31;
        }
    }
    static public boolean validarData(String data){

        String[] splitData = data.split("-");
        int dia = Integer.parseInt(splitData[0]);
        int mes = Integer.parseInt(splitData[1]);
        int ano = Integer.parseInt(splitData[2]);

        boolean validar = false;

        if (mes >= 1 && mes <= 12) {
            int diasNoMes = diasMes(mes, ano);
            if (dia >= 1 && dia <= diasNoMes) {
                validar = true;
            }
        }

        return validar;
    }
    static public boolean validarHora(LocalTime localTime) {

        if (localTime.getHour() >= 0 && localTime.getHour() <= 23 && localTime.getMinute() >= 0 && localTime.getMinute() <= 59)
            return true;
        return false;
    }
    static public java.sql.Date convertToSqlDate(String date) {
        // Formatar a Date para o formato desejado ("DD/MM/YYYY")
        SimpleDateFormat dateFormat = new SimpleDateFormat("DD/MM/YYYY");
        String formattedDate = dateFormat.format(date);

        try {
            // Converter a String formatada de volta para Date
            Date parsedDate = dateFormat.parse(formattedDate);

            // Criar um java.sql.Date a partir do Date parseado
            return new java.sql.Date(parsedDate.getTime());
        } catch (Exception ex) {
            ex.printStackTrace(); // Lide com a exceção de formatação ou análise aqui
            return null;
        }
    }

    /**
     * Recebe uma hora em formato hh:mm e devolve em valores separados
     * @param time a hora no formato hh:mm
     * @return um par hora - minuto, ambos ints
     */
    public static MutablePair<Integer, Integer> timeStringToIntPair(String time) {
        String[] times = time.split(":");
        return new MutablePair<>(Integer.parseInt(times[0]), Integer.parseInt(times[1]));
    }

    public static String timeIntPairToString(Pair<Integer, Integer> time) {
        return String.format("%02d:%02d", time.getLeft(), time.getRight());
    }

    /**
     * Adds a time to an hour integer pair
     * @param currentTime the current time <hour,minute></hour,minute>
     * @param minutesToAdd the time to add, in minutes
     * @return true if midnight was reached, false if not
     */
    public static boolean addTime(MutablePair<Integer, Integer> currentTime, int minutesToAdd) {
        boolean passsedMidnight = false;
        currentTime.setRight(currentTime.getRight() + minutesToAdd);
        while (currentTime.getRight() > 59) {
            currentTime.setLeft(currentTime.getLeft() + 1);
            currentTime.setRight(currentTime.getRight() - 60);
        }
        while (currentTime.getLeft() > 23) {
            currentTime.setLeft(currentTime.getLeft() - 24);
            passsedMidnight = true;
        }
        return passsedMidnight;
    }

    public static int timeDifference(Pair<Integer,Integer> time1, Pair<Integer,Integer> time2) {
        return 60 * (time1.getLeft() - time2.getLeft()) + time1.getRight() - time2.getRight();
    }

    public static void saveDotFile(String dotContent, String filePath) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            writer.write(dotContent);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}