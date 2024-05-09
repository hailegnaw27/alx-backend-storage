-- Script to create a trigger that decreases the quantity of an item after adding a new order
-- Trigger should activate after an INSERT operation on the orders table

DELIMITER //

CREATE TRIGGER decrease_item_quantity
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Decrease the quantity of the ordered item in the items table
    UPDATE items
    SET quantity = quantity - NEW.number
    WHERE name = NEW.item_name;
END;
//

DELIMITER ;

