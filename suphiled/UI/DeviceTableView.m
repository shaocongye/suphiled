//
//  DeviceTableView.m
//  HRVTableView
//
//  Created by Hamidreza Vakilian on 25/11/2013
//  Copyright (c) 2013 Hamidreza Vakilian. All rights reserved.
//  Website: http://www.infracyber.com/
//  Email:   xerxes235@yahoo.com
//

#import "DeviceTableView.h"

@implementation DeviceTableView
@synthesize viewDelegate, viewDataSource;

- (id)initWithFrame:(CGRect)frame expandOnlyOneCell:(BOOL)_expandOnlyOneCell enableAutoScroll: (BOOL)_enableAutoScroll
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		expandOnlyOneCell = _expandOnlyOneCell;
		if (!expandOnlyOneCell)
			expandedIndexPaths = [[NSMutableArray alloc] init];
		
		enableAutoScroll = _enableAutoScroll;
		
		self.delegate = self;
		self.dataSource = self;
		
    }
    return self;
}


//////// IMPORTANT!!!!!!!!!!!!!!!!!!!!!
//////// UITableViewDataSource Protocol Forwarding
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [viewDataSource tableView:tableView numberOfRowsInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [viewDataSource numberOfSectionsInTableView:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([viewDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
        return [viewDataSource tableView:tableView titleForHeaderInSection:section];
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{	if ([viewDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)])
	return [viewDataSource tableView:tableView titleForFooterInSection:section];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{	if ([viewDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
	return [viewDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([viewDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
        return [viewDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
	return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if ([viewDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
        return [viewDataSource sectionIndexTitlesForTableView:tableView];
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if ([viewDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
        return [viewDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
	return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([viewDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        return [viewDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	if ([viewDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
        return [viewDataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [viewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
	
	if (expandOnlyOneCell)
	{
		if (actionToTake == 0) // e.g. the first time or an expanded cell from before gets in to view
		{
			if (selectedIndexPath)
				if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
				{
					cell = [viewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:YES];//i want it expanded
					return cell;
				}
			
			return cell; //it's already collapsed!
		}
		
		if(actionToTake == -1)
		{
			[viewDataSource tableView:tableView collapseCell:cell withIndexPath:indexPath];
			actionToTake = 0;
		}
		else
		{
			[viewDataSource tableView:tableView expandCell:cell withIndexPath:indexPath];
			actionToTake = 0;
		}
	}
	else
	{
		if (actionToTake == 0) // e.g. the first time or an expanded cell from before gets in to view
		{
			BOOL alreadyExpanded = NO;
			NSIndexPath* correspondingIndexPath;
			for (NSIndexPath* anIndexPath in expandedIndexPaths) {
				if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
				{alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
			}
            
			if (alreadyExpanded)
                cell = [viewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:YES];
			else
				cell = [viewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
            
			return cell; //it's already collapsed!
            
		}
		
		if(actionToTake == -1)
		{
			[viewDataSource tableView:tableView collapseCell:cell withIndexPath:indexPath];
			actionToTake = 0;
		}
		else
		{
			[viewDataSource tableView:tableView expandCell:cell withIndexPath:indexPath];
			actionToTake = 0;
		}
	}
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (expandOnlyOneCell)
	{
		if (selectedIndexPath)
            if(selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                return [viewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:YES];
		
		return [viewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:NO];
	}
	else
	{
		BOOL alreadyExpanded = NO;
		NSIndexPath* correspondingIndexPath;
        
		for (NSIndexPath* anIndexPath in expandedIndexPaths) {
			if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
			{alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
		}
        
		if (alreadyExpanded)
			return [viewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:YES];
		else
			return [viewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:NO];
	}
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (expandOnlyOneCell)
	{
		if (selectedIndexPath)
            if (selectedIndexPath.row != -1 && selectedIndexPath.row != -2) //collapse the last expanded item (if any)
            {
                BOOL dontExpandNewCell = NO;
                if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                    dontExpandNewCell = YES;
                
                NSIndexPath* tmp = [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:selectedIndexPath.section];//tmp now holds the last expanded item
                selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                
                actionToTake = -1;
                
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmp] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                
                if (dontExpandNewCell) return; //the same expanded cell was touched and now I collapsed it. No new cell is touched
            }
		
		actionToTake = 1;
		///expand the new touched item
		
		selectedIndexPath = indexPath;
		[tableView beginUpdates];
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		[tableView endUpdates];
		if (enableAutoScroll)
			[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
		
	}
	else
	{
		BOOL alreadyExpanded = NO;
		NSIndexPath* correspondingIndexPath;
		for (NSIndexPath* anIndexPath in expandedIndexPaths) {
			if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
			{alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
		}
		
		if (alreadyExpanded)////collapse it!
		{
			actionToTake = -1;
			[expandedIndexPaths removeObject:correspondingIndexPath];
			[tableView beginUpdates];
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			[tableView endUpdates];
		}
		else ///expand it!
		{
			actionToTake = 1;
			[expandedIndexPaths addObject:indexPath];
			[tableView beginUpdates];
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			[tableView endUpdates];
			if (enableAutoScroll)
				[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
		}
	}
}


@end
