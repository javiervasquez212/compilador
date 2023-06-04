package com.compiler;
import java.util.HashMap;
import java.util.Stack;

public class SymbolTable {
    private Stack<HashMap<String, SymbolInfo>> scopes;

    public SymbolTable() {
        scopes = new Stack<>();
        scopes.push(new HashMap<>());  // push a new scope for global variables
    }
    
    public void pushScope() {
        scopes.push(new HashMap<>());
    }
    public void popScope() {
        scopes.pop();
    }
    public void addSymbol(String identifier, SymbolInfo info) {
        scopes.peek().put(identifier, info);
    }
    public SymbolInfo getSymbol(String identifier) {
        for (int i = scopes.size() - 1; i >= 0; i--) {
            HashMap<String, SymbolInfo> scope = scopes.get(i);
            if (scope.containsKey(identifier)) {
                return scope.get(identifier);
            }
        }
        return null;  // not found in any scope
    }


    public void printSymbolTable() {
        int scopeIndex = 0;
        for (HashMap<String, SymbolInfo> scope : scopes) {
            System.out.println("Alcance " + scopeIndex + ":");
            for (String key : scope.keySet()) {
                SymbolInfo info = scope.get(key);
                System.out.println("    Identificador: " + key);
                System.out.println("    Tipo: " + info.getType());
                System.out.println("    Valor: " + info.getValue());
                System.out.println();
            }
            scopeIndex++;
        }
    }
}
