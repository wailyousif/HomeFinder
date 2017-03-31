package com.ironyard.repo;

import com.ironyard.data.Address;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * Created by wailm.yousif on 3/22/17.
 */
public interface AddressRepo extends PagingAndSortingRepository<Address, Long> {
}
