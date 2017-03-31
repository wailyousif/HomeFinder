package com.ironyard.repo;

import com.ironyard.data.Property;
import com.ironyard.data.UpdatedProperty;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by wailm.yousif on 3/28/17.
 */

public interface UpdatedPropertyRepo extends PagingAndSortingRepository<UpdatedProperty, Long>
{
    public UpdatedProperty findByProperty(Property property);
}
