/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cellular_automata;

/**
 *
 * @author Estudiante
 */
public class Automata {
    
    int[][][] next = new int[2][2][2];
    
    public Automata(int n) {
        for(int i = 0; i < 2; i++)
            for(int j = 0; j < 2; j++)
                for(int k = 0; k < 2; k++) {
                    next[i][j][k]= n & 1;
                    n >>= 1;
                }
    }
    
    public int next(int v1, int v2, int v3) {
        return next[v1][v2][v3];
    }
    
}
