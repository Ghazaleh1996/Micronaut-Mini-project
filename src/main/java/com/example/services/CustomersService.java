package com.example.services;

import com.example.dao.Customer;
import com.example.dao.Transaction;
import io.micronaut.cache.annotation.CacheConfig;
import io.micronaut.cache.annotation.CachePut;
import io.micronaut.cache.annotation.Cacheable;
import io.micronaut.serde.annotation.Serdeable;
import jakarta.inject.Singleton;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import io.micronaut.scheduling.annotation.Scheduled;
import java.time.LocalDate;
import java.util.List;


@Singleton
@Slf4j

public class CustomersService {

    @PersistenceContext
    EntityManager em;

    @Transactional

    public List<Customer> list() {
        return em
            .createQuery("SELECT c FROM Customer c", Customer.class)
            .getResultList();
    }

    @Transactional

    public Customer find(int id) {
        return em
            .createQuery("SELECT c FROM Customer c WHERE c.id = :customerId", Customer.class)
            .setParameter("customerId", id)
            .getSingleResult();
    }

    @Transactional

    public Customer update(int customerId, String name, String surname) {
        var customer = em.find(Customer.class, customerId);
        customer.setName(name);
        customer.setSurname(surname);
        em.merge(customer);
        log.debug("updated customer {}", customerId);
        return customer;
    }

    @Transactional

    public Customer update(int id, int points,int delta,String name, String surname) {
        var customer=em.find(Customer.class, id);
        customer.setName(name);
        customer.setSurname(surname);
        int newPoints= customer.getPoints()+delta;
        customer.setPoints(newPoints);
        em.merge(customer);
        log.debug("updated customer points {}",id);
        return customer;
    }

    //Retrieve summary data: number of customers, total circulating points
    @Transactional

    public SummaryDTO getSummaryData(){
        Long totalCustomers =em.createQuery("SELECT count(c) FROM Customer c", Long.class)
                .getSingleResult();
        Long totalPoints = em.createQuery("SELECT SUM(c.points) FROM Customer c", Long.class)
                .getSingleResult();

        var dto = new SummaryDTO();
        dto.setCustomerCount(totalCustomers.intValue());
        dto.setTotalPoints(totalPoints.intValue());
        return dto;
    }

    @Transactional
    public Customer findByUsername(String username) {
        List<Customer> results = em.createQuery("SELECT c FROM Customer c WHERE LOWER(c.username) = :username", Customer.class)
                .setParameter("username", username.toLowerCase().trim())
                .getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    @Getter @Setter @Serdeable
    public static class SummaryDTO {
        long customerCount;
        long totalPoints;
    }

    //Add/remove points from a customer
    @Transactional

    public Customer summary(int customerId, int points) {
        var customer=em.find(Customer.class, customerId);
        int newPoints= customer.getPoints()+points;
        customer.setPoints(newPoints);
        em.merge(customer);
        var tx = new Transaction();
        tx.setCustomer(customer);
        //tx.setPoints(points);
        em.persist(tx);
        log.debug("updated customer points {}",customerId);
        return customer;
    }

    @Scheduled(cron = "0 0 0 1 1 *")
    @Transactional
    public void resetAllCustomerPoints() {
        int updated = em.createQuery("UPDATE Customer c SET c.points = 0")
                .executeUpdate();
        log.info("Reset points on January 1st. Total updated: " + updated);

    }

    @Scheduled(cron = "0 0 0 * * *")
    @Transactional
    public void rewardBirthdayCustomers() {
        var today = LocalDate.now();

        List<Customer> customers = em.createQuery("SELECT c FROM Customer c", Customer.class)
                .getResultList();
        for (Customer c : customers) {
            if (c.getBirthday() != null &&
                    c.getBirthday().getMonthValue() == today.getMonthValue() &&
                    c.getBirthday().getDayOfMonth() == today.getDayOfMonth()) {

                c.setPoints(c.getPoints() + 10);
                em.merge(c);
                log.info(" Birthday points added to: {}", c.getUsername());
            }
        }
    }

}
