package com.ironyard.repo;

import com.ironyard.data.ContactInfo;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by wailm.yousif on 3/22/17.
 */
public interface ContactInfoRepo extends PagingAndSortingRepository<ContactInfo, Long> {
}
