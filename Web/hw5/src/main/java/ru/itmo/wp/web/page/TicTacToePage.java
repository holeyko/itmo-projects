package ru.itmo.wp.web.page;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

public class TicTacToePage {
    private void action(HttpServletRequest request, Map<String, Object> view) {
        State state = (State) request.getServletContext().getAttribute("state");

        if (state == null) {
            state = new State();
            request.getServletContext().setAttribute("state", state);
        }

        view.put("state", state);
    }

    private void onMove(HttpServletRequest request, Map<String, Object> view) {
        State state = (State) request.getServletContext().getAttribute("state");

        if (state == null) {
            // TODO: write smth
            return;
        }

        for (Map.Entry<String, String[]> e : request.getParameterMap().entrySet()) {
            String cellStart = "cell_";
            if (e.getKey().startsWith(cellStart)) {
                if (e.getKey().length() != 7) {
                    // TODO: Do smth
                }

                int row, column;
                try {
                    row = Character.digit(e.getKey().charAt(cellStart.length()), 10);
                    column = Character.digit(e.getKey().charAt(cellStart.length() + 1), 10);
                } catch (NumberFormatException exception) {
                    //TODO: do smth
                    return;
                }

                state.makeMove(row, column);
                request.getServletContext().setAttribute("state", state);
                view.put("state", state);
            }
        }
    }

    private void newGame(HttpServletRequest request, Map<String, Object> view) {
        State state = new State();
        request.getServletContext().setAttribute("state", state);
        view.put("state", state);
    }

    public class State {
        private int size;
        private int countFilled = 0;
        private boolean crossesMove = true;
        private final String[][] cells;
        private Phase phase = Phase.RUNNING;

        public State() {
            this(3);
        }

        public State(int size) {
            this.size = size;
            cells = new String[size][size];
        }

        private void makeMove(int row, int column) {
            cells[row][column] = crossesMove ? "X" : "O";
            ++countFilled;
            updatePhase();
            crossesMove = !crossesMove;
        }

        private void updatePhase() {
            for (int row = 0; row < size; ++row) {
                for (int column = 0; column < size; ++column) {
                    for (int dr = -1; dr <= 1; ++dr) {
                        for (int dc = -1; dc <= 1; ++dc) {
                            if (checkWinFromCell(row, column, dr, dc)){
                                phase = crossesMove ? Phase.WON_X : Phase.WON_O;
                                return;
                            }
                        }
                    }
                }
            }

            if (countFilled == size * size) {
                phase = Phase.DRAW;
            }
        }

        private boolean checkWinFromCell(int row, int column, int dr, int dc) {
            if (dr == dc && dc == 0) {
                return false;
            }

            String cellValue = cells[row][column];
            int curRow = row, curColumn = column;
            int maxSequenceSize = cellValue == null ? 0 : 1;
            int curSequenceSize = cellValue == null ? 0 : 1;

            while (0 <= curRow + dr && curRow + dr <= size - 1 &&
                    0 <= curColumn + dc && curColumn + dc <= size - 1)   {
                curRow += dr;
                curColumn += dc;

                if (cellValue == null) {
                    cellValue = cells[curRow][curColumn];
                } else if (cells[curRow][curColumn] != null && cells[curRow][curColumn].equals(cellValue)) {
                    ++curSequenceSize;
                } else {
                    maxSequenceSize = Math.max(maxSequenceSize, curSequenceSize);
                    cellValue = cells[curRow][curColumn];
                    curSequenceSize = cellValue == null ? 0 : 1;
                }
            }

            maxSequenceSize = Math.max(maxSequenceSize, curSequenceSize);
            if (maxSequenceSize == size) {
                return true;
            }

            return false;
        }

        public int getSize() {
            return size;
        }

        public boolean isCrossesMove() {
            return crossesMove;
        }

        public String[][] getCells() {
            return cells;
        }

        public Phase getPhase() {
            return phase;
        }
    }

    enum Phase {
        RUNNING, WON_X, WON_O, DRAW
    }
}
