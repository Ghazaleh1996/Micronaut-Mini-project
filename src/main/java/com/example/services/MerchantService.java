package com.example.services;
import com.example.dao.Customer;
import com.example.dao.Transaction;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Singleton
@Slf4j
public class MerchantService {
    @PersistenceContext
    EntityManager em;

}
