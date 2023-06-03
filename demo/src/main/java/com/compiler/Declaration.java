package com.compiler;

public class Declaration {
    private Type type;
    
    public Declaration(Type type, String id, Expression expression) {
        this.type = type;
        this.id = id;
        this.expression = expression;
    }
    public Declaration(Type type, String id) {
        this(type, id, null);
    }
    public Type getType() {
        return type;
    }
    public void setType(Type type) {
        this.type = type;
    }
    private String id;
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    private Expression expression;
    
    public Expression getExpression() {
        return expression;
    }
    public void setExpression(Expression expression) {
        this.expression = expression;
    }
}
