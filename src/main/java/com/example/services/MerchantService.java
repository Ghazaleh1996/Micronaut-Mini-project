package com.example.services;
import com.example.dao.Customer;
import com.example.dao.Transaction;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Singleton
@Slf4j
public class MerchantService {
    @PersistenceContext
    EntityManager em;
    //Retrieve point balance and personal data
    @Transactional
    public Map<String, Integer> getCustomerInfo() {

        List<Customer> customerList =em.createQuery("SELECT * FROM Customer c", Customer.class)
                .getResultList();
        Long totalPoints = em.createQuery("SELECT SUM(c.points) FROM Customer c", Long.class)
                .getSingleResult();

        Map<String, Integer> customerInfo = new HashMap<>();
        for (Customer customer : customerList) {

            customerInfo.put("totalPoints", totalPoints.intValue());
            customerInfo.("customerInfo", customer);

            return customerInfo;
        }
    }
    //Retrieve transaction history
    @Transactional
    public List<Transaction> historyList(){
            List<Transaction> transactionHistory =em.createQuery("Select t.timestamp , t.points From Transaction t",Transaction.class)
                    .getResultList();
            return transactionHistory;
    }
    //Edit personal data
    @Transactional
    public Customer editPersonalData(int customerId, String name, String surname) {
        var customer = em.find(Customer.class, customerId);
        customer.setName(name);
        customer.setSurname(surname);
        em.merge(customer);
        log.debug("updated", customerId);
        return customer;
    }
    @Transactional
    public Customer signUp(int customerId, String name, String surname) {
        var customer =em.find(Customer.class, customerId)
                        .equals("INSERT INTO customer (name, surname) values (:name, :surname)", Customer.class);
        
    }
}
