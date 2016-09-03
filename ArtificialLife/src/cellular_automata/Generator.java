/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package artificiallife;

/**
 *
 * @author Estudiante
 */
public class Generator {
    
    public static void main(String[] args) {
        int size = 150;
        int rule = 110;
        int steps = 200;
        
        Automata automata = new Automata(rule);
        
        int[] world = new int[size];
        for(int i = 0; i < size; i++)
            world[i] = (Math.random() < 0.5)? 0 : 1;
        //world[size / 2] = 1;
        
        int[] temp = new int[size];
        for(int i = 0; i < steps; i++) {
            for(int j = 0; j < size; j++) {
                temp[j] = automata.next(world[(j + size - 1) % size], world[j], world[(j + 1) % size]);
                if(world[j] == 0)
                    System.out.print(" ");
                else
                    System.out.print(world[j]);
            }
            System.out.println();
            System.arraycopy(temp, 0, world, 0, size);
        }
        for(int j = 0; j < size; j++)
            if(world[j] == 0)
                    System.out.print(" ");
                else
                    System.out.print(world[j]);
        System.out.println();
    }
    
}
