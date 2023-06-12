class CfgWeapons
{
    class ItemCore;
    class InventoryItem_Base_F;
    
    class SE_Steel: ItemCore
    {
        author="studzy";
        displayName = "Steel";
        scope = 2;      
        simulation= "ItemMineDetector";
        picture = "\soprot\ui\items\steel_x_ca.paa";
        descriptionShort = "A hard, strong grey alloy of iron with carbon and usually other elements, used as a structural and fabricating material.";
        class ItemInfo: InventoryItem_Base_F
        {
            mass=7;
        };
    };

    class SE_Wood: ItemCore
    {
        author = "studzy";
        displayName="Wood";
        scope=2;
        simulation="ItemMineDetector";
        picture="\soprot\ui\items\wood_x_ca.paa";
        descriptionShort = "A porous and fibrous structural tissue found in the stems and roots of trees and other woody plants.";
        class ItemInfo: InventoryItem_Base_F
        {
            mass=7;
        };
    };
};