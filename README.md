# RPN Calculator - Reverse Polish Notation Evaluator

**Author:** Jimmy Lin
**Framework:** Ruby on Rails
**Built by:** [vibe8.app](https://vibe8.app)

A professional-grade Ruby on Rails application implementing Reverse Polish Notation (RPN) expression evaluation with enterprise-scale system architecture design.

## 📋 Project Structure

This project consists of two main parts:

### **PART 1: RPN Calculator Implementation**
- Stack-based RPN evaluation algorithm
- Ruby on Rails web interface
- Comprehensive unit testing
- Modern responsive UI/UX

### **PART 2: System Design Exercise**
- High-volume real-time data engineering architecture
- Kafka-based message processing pipeline
- Scalable processing nodes and fault tolerance
- Enterprise monitoring and alerting strategies

## 🎯 Overview

This application demonstrates both algorithmic implementation and system architecture design, showcasing how a simple RPN calculator can scale to handle enterprise-level data processing workloads.

## 🔧 PART 1: RPN Algorithm Implementation

### Core RPN Evaluation Process

The calculator uses a **stack-based algorithm** with O(n) time complexity:

1. **Tokenization**: Split input into numbers and operators
2. **Stack Processing**: Numbers → Push onto stack; Operators → Pop two operands, compute, push result
3. **Validation**: Ensure exactly one result remains
4. **Error Handling**: Comprehensive validation for edge cases

### Supported Operations

- **Addition** (`+`), **Subtraction** (`-`), **Multiplication** (`*`)
- **Division** (`/`) with zero-division protection
- **Exponentiation** (`^`) with overflow validation

### Sample Test Cases
```
"10 3 +"     → 13
"10 3 2 + -" → 5  (equivalent to 10 - (3 + 2))
"10 3 * 2 ^" → 900 (equivalent to (10 * 3)^2)
```

## 🏗️ PART 2: System Design Exercise

![System Architecture Diagram](data%20architecture.png)

### High-Volume Real-Time RPN Expression Evaluation System

This section addresses enterprise-scale processing of RPN expressions in a distributed system architecture.

#### **Data Ingestion**
**How we ingest real-time data from Kafka:**
- Web UI Layer (Rails) receives user expressions via POST /evaluate endpoint
- API Server validates RPN input and publishes to Kafka topic `rpn-expressions`
- Kafka acts as the central message broker for reliable data ingestion

#### **Processing Nodes**
**How we scale evaluation logic for high volume:**
- Stateless RPN Evaluator processes expressions using the same algorithm from Part 1
- Auto-scaling based on Kafka consumer lag and throughput demands
- Horizontal scaling ensures processing of 10,000+ expressions/second

#### **Data Flow and Integration**
**How we route results to multiple downstream systems:**
- Kafka topics: `rpn-expressions` (input), `evaluated-results` (output), `evaluation-failures` (DLQ)
- Downstream consumers: Real-time Dashboard, Analytics Database, Operational Systems
- End-to-end flow: Web UI → API Server → Kafka → RPN Processor → Multiple Consumers

#### **Reliability and Fault Tolerance**
**How we ensure high availability and handle failures:**
- Auto-scaling processors based on consumer lag metrics
- Stateless design allows any processor to handle any expression
- Dead Letter Queue (`evaluation-failures`) for failed processing
- Kafka message persistence and replication for data durability
- Circuit breakers prevent cascade failures to downstream systems

#### **Monitoring and Alerting**
**How we implement monitoring for system health and data quality:**
- System monitoring with custom metrics and dashboards
- Key metrics: processing latency, success rate, throughput, error rate
- Alerting strategy: Critical (immediate call), Warning (email), Info (Slack)
- Data quality assurance with input validation and result verification
- SLA monitoring: 99.9% uptime, <100ms processing time, 10K+/sec throughput

## 🧪 Testing & Quality Assurance

### Comprehensive Test Suite
**Location:** `spec/models/rpn_calculator_spec.rb`, `spec/controllers/rpn_controller_spec.rb`

**Coverage includes:**
- **Unit Tests**: All RPN operations and edge cases (21 test cases)
- **Controller Tests**: Web interface and error handling
- **Edge Cases**: Division by zero, insufficient operands, invalid tokens
- **Sample Data**: All provided test cases from requirements

### Running Tests
```bash
bundle exec rspec                              # Run all tests
bundle exec rspec spec/models/rpn_calculator_spec.rb    # Model tests only
```

## 🐳 Deployment

### Docker Deployment
```bash
docker-compose up -d    # Start all services
# Access at http://localhost:3000
```

### Dokploy Deployment (Recommended)

**Prerequisites:**
- Dokploy server running
- Git repository access
- Domain name (optional)

**Deployment Steps:**
1. **Connect Repository**: Add Git repository to Dokploy
2. **Auto-Detection**: Dokploy automatically detects Ruby on Rails + Docker
3. **Environment Variables**: Set `SECRET_KEY_BASE` (auto-generated if not provided)
4. **Deploy**: Dokploy builds and deploys automatically
5. **Access**: Application available at assigned URL

**Configuration Files:**
- `Dockerfile`: Multi-stage production build
- `docker-compose.yml`: Simplified for Dokploy
- `docker-entrypoint.sh`: Database setup and initialization
- `dokploy.json`: Dokploy-specific configuration

**Features:**
- ✅ Auto-scaling (1-3 replicas based on CPU)
- ✅ Health checks and monitoring
- ✅ Persistent SQLite database storage
- ✅ SSL/TLS termination via Dokploy
- ✅ Zero-downtime deployments

## 🛠️ Development Setup

### Local Development
```bash
cd RubyRPN
bundle install          # Install dependencies
rails db:create db:migrate  # Setup database
bundle exec rspec       # Run tests
rails server           # Start development server
# Visit http://localhost:3000
```

## 📁 Project Structure
```
RubyRPN/
├── app/models/rpn_calculator.rb     # Core RPN algorithm (Part 1)
├── app/controllers/rpn_controller.rb # Web interface controller
├── app/views/rpn/index.html.erb     # UI with Part 1 & Part 2 sections
├── spec/                            # Comprehensive test suite
├── data architecture.png            # System architecture diagram
├── Dockerfile & docker-compose.yml  # Deployment configuration
└── README.md                        # This documentation
```

## 🎯 Key Features

### Part 1: RPN Calculator
- Stack-based algorithm with O(n) complexity
- Comprehensive error handling and validation
- Modern responsive web interface
- 100% test coverage with edge cases

### Part 2: System Architecture
- Enterprise-scale Kafka-based processing pipeline
- Auto-scaling stateless processors
- Fault tolerance with Dead Letter Queues
- Comprehensive monitoring and alerting

---

**Author:** Jimmy Lin
**Built by:** [vibe8.app](https://vibe8.app) with Ruby on Rails

*Demonstrates stack-based algorithms and enterprise system design for data engineering applications.*