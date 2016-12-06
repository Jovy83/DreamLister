# DreamLister

My attempt at the DreamLister challenge.  

So far there's 2 issues:  

1. adding a new Item causes the pickerview's 2nd column to produce an extra blank row  

2. an issue with saving a new Item with the same Store and ItemType overwrites a previous Item with the same Store and ItemType, and makes it a duplicate of the new Item

  
Solutions  
1. this is because we were creating a new ItemType each time we were creating a new Item which is unnecessary. we got carried away by the fact that we had to create an Image for each Item that we accidentally also created an ItemType for each Item. This is unnecessary because we already created the ItemTypes in the generateTestData function. So just set the Item's toItemType attribute to whatever row is selected on the pickerView's 2nd column  

2. this was because we had the ItemType's toItem's' attribute relationship set to "To One". This should be set to "To Many" because for example, the Electronics ItemType can be shared by an iPhone and a DesktopPC. Lesson to learn: check to see your entity relationships are correct before coding. 
