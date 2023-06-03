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
}
