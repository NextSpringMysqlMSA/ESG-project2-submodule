# ESG 데이터 기반 협력사 관리 및 리스크 대응 서비스

**2025.05.02 ~ 2025.05.20**

## 프로젝트 개요

- **프로젝트명**: ESG 데이터 기반 협력사 관리 및 리스크 대응 서비스
- **개발 기간**: 2025.05.02 ~ 2025.05.20
- **수행 방식**: **팀 프로젝트** (6명 - **김동환(팀장)**, 박창현, 김지현, 한광구, 이돈민, 지희연)
- GitHub: [https://github.com/orgs/NextSpringMysqlMSA/repositories](https://github.com/orgs/NextSpringMysqlMSA/repositories)

## 프로젝트 상세

시스템 개요 ESG 데이터 기반 협력사 관리 및 리스크 대응 서비스입니다. 기업이 IFRS S2와 GRI 표준에 따른 ESG 공시 데이터를 체계적으로 관리하고, EU 공급망 실사 요구사항을 준수할 수 있도록 지원하는 시스템을 개발했습니다.

**주요 요구사항**

- ESG 공시 관리: IFRS S2(TCFD) 및 GRI 표준 기반 ESG 데이터 관리
- 공급망 실사 : EU 공급망 실사, 인권 실사, 환경 실사 자가 진단 체크리스트
- 협력사 관리: 파트너사 등록 및 재무리스크 모니터링
- NetZero 시뮬레이션 : SSP 시나리오 기반 기후 분석 및 탄소 중립 로드맵 제공

**구현 기능**

- ESG 공시 섹션에서 IFRS S2 기준에 따른 거버넌스(위원회 구성, 회의 관리, 경영진 KPI, 환경교육), 전략(SSP 시나리오 분석, NetCDF 파일 기반 데이터 처리, 물리적/전환 리스크 관리), 목표 및 지표(넷제로 분석 결과, KPI 목표 설정) 관리 기능을 구현했습니다.
- GRI 표준(GRI 2, 3, 200, 300, 400)에 맞춘 데이터 입력 시스템과 공급망 실사 기능(EU 공급망 실사, 인권 실사, 환경 실사)을 제공합니다. 협력사 관리 섹션에서는 DART API를 연동한 파트너사 관리와 재무리스크 관리 기능을 통해 협력사의 ESG 데이터와 재무 현황을 모니터링 할 수 있습니다.
- MSA 아키텍처로 설계하고 AWS EKS Fargate를 통해 서버리스 환경에서 배포했습니다.

## 담당 역할

- **MSA 인프라 설계 및 구축**
  - **config-service:** GitHub 연동 Spring Cloud Config 서버로 환경 변수 중앙 관리를 구현했습니다.
  - **discovery-service:** Eureka 서비스 디스커버리 서버를 구축하여 서비스들 간 통신을 관리했습니다.
  - **gateway-service:** Spring Cloud Gateway를 통한 API 라우팅, JWT 인증 디코딩 구현하여 각 서비스에 별도 Auth 호출 없이 헤더 값만으로 사용자 인증이 가능하도록 하였습니다.
- **인증 및 회원 관리 시스템**
  - **auth-service:** JWT 기반 로그인 회원가입 시스템을 개발했습니다. Gateway와 연동하여 토큰 검증과 사용자 정보 전달 시스템을 구축했습니다.
- **ESG 핵심 비즈니스 로직 개발**
  - **tcfd-service:** IFRS S2(TCFD) 기준에 따른 거버넌스, 전략, 목표 관리 시스템을 개발했습니다.
  - **gri-service:** GRI 표준 기준 항목을 입력 및 진행률 계산 시스템을 구현했습니다.
  - **dashboard-service:** ESG 공시 진행률, 배출량 현황, NetZero 달성 경로 등 종합한 대시보드 API를 개발했습니다.
- **풀스택 통합 및 팀 관리**
  - **frontend:** Next.js 기반 프론트엔드 개발에서 UI/UX 방향성을 제시하고, 백엔드 API와의 연결 작업을 담당했습니다.
  - **팀장:** 6명 팀의 팀장으로서 csddd-service(공급망 실사), dart-service(DART 연동) 등 팀원 개발 서비스와의 통합을 관리하였습니다.
  - **AWS:** EKS Fargate 배포용 YAML 파일을 작성하여 비용 최적화된 서버리스 환경에서 배포했습니다.

## 기술 스택

- **Backend**: Spring Boot, Spring Cloud (Config, Gateway, Eureka)
- **Frontend**: Next.js, TypeScript, Tailwind CSS
- **Database**: MySQL
- **Authentication**: JWT, Spring Security
- **Cloud & DevOps**: AWS EKS Fargate, Docker, Kubernetes
- **External APIs**: DART API
- **Architecture**: MSA, RESTful API

---

## AWS 아키텍처

![AWS 구조도.png](/Users/donghwan/Documents/code/ESGProject_2/backend/ESG-project2-submodule/images/AWS구조도.png)

## EKS 클러스터와 AWS Fargate 도입

**[도입 배경]**

프로젝트 초기에는 EC2 노드 기반으로 EKS 클러스터를 구성했지만, 마이크로서비스 수가 늘어나면서 **EC2 노드 관리 부담**, **운영체제 패치**, **리소스 효율성 문제**가 발생했습니다.

**[선택 이유]**

- **서버리스 아키텍처**: 서버 관리 없이 컨테이너 실행
- **운영 오버헤드 감소**: 인프라 관리 시간 획기적 절약
- **비용 효율성**: 사용한 만큼의 vCPU와 메모리 리소스만 과금

**[도입 성과]**

- **운영 효율성 향상**: 인프라 관리 시간 절약으로 핵심 개발에 집중
- **인프라 비용 절감**: 유휴 EC2 인스턴스 유지 비용 절약
- **배포 속도 향상**: 서버 프로비저닝 단계 제거로 빠른 배포

---

### 시스템 아키텍처

이 프로젝트는 Spring Cloud 기반의 마이크로서비스 아키텍처로 구성되어 있으며, 다음과 같은 서비스들로 구성됩니다:

- **Discovery Service**: 서비스 디스커버리 (Eureka)
- **Gateway Service**: API 게이트웨이 및 인증 라우팅
- **Auth Service**: 사용자 인증 및 권한 관리
- **TCFD Service**: TCFD (Task Force on Climate-related Financial Disclosures) 보고서 관리
- **CSDD Service**: CSDD (Corporate Sustainability Due Diligence) 관리
- **GRI Service**: GRI (Global Reporting Initiative) 표준 관리
- **Dashboard Service**: 데이터 대시보드 및 시각화

## 서비스별 설정 정보

### 1. Discovery Service

- **포트**: 8761
- **역할**: Eureka 서비스 디스커버리 서버
- **환경변수**: 없음
- **의존성**: 없음

### 2. Gateway Service

- **포트**: 8080
- **역할**: API 게이트웨이, 요청 라우팅, JWT 인증
- **환경변수**:
  - `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: Eureka 서버 URL
  - `JWT_SECRET`: JWT 토큰 암호화 키
- **의존성**: Discovery Service

### 3. Auth Service

- **포트**: 8081
- **역할**: 사용자 인증, 회원가입, JWT 토큰 발급, 이미지 업로드
- **환경변수**:
  - `DB_URL`: 데이터베이스 연결 URL
  - `DB_USERNAME`: 데이터베이스 사용자명
  - `DB_PASSWORD`: 데이터베이스 비밀번호
  - `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: Eureka 서버 URL
  - `JWT_SECRET`: JWT 토큰 암호화 키
- **AWS 서비스**: S3 (esg-storage-bucket, ap-northeast-2)
- **의존성**: Discovery Service, 데이터베이스

### 4. TCFD Service

- **포트**: 8082
- **역할**: TCFD 보고서 데이터 관리
- **환경변수**:
  - `DB_URL`: 데이터베이스 연결 URL
  - `DB_USERNAME`: 데이터베이스 사용자명
  - `DB_PASSWORD`: 데이터베이스 비밀번호
  - `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: Eureka 서버 URL
- **AWS 서비스**: S3 (esg-storage-bucket, ap-northeast-2)
- **의존성**: Discovery Service, 데이터베이스

### 5. CSDD Service

- **포트**: 8083
- **역할**: CSDD 데이터 관리
- **환경변수**:
  - `DB_URL`: 데이터베이스 연결 URL
  - `DB_USERNAME`: 데이터베이스 사용자명
  - `DB_PASSWORD`: 데이터베이스 비밀번호
  - `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: Eureka 서버 URL
- **의존성**: Discovery Service, 데이터베이스

### 6. GRI Service

- **포트**: 8084
- **역할**: GRI 표준 데이터 관리
- **환경변수**:
  - `DB_URL`: 데이터베이스 연결 URL
  - `DB_USERNAME`: 데이터베이스 사용자명
  - `DB_PASSWORD`: 데이터베이스 비밀번호
  - `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: Eureka 서버 URL
- **의존성**: Discovery Service, 데이터베이스

### 7. Dashboard Service

- **포트**: 8085
- **역할**: 데이터 대시보드 및 시각화
- **환경변수**:
  - `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: Eureka 서버 URL
- **의존성**: Discovery Service

## 환경 설정 가이드

### 필수 환경변수

| 환경변수                                | 설명                      | 예시값                                      | 사용 서비스                  |
| --------------------------------------- | ------------------------- | ------------------------------------------- | ---------------------------- |
| `DB_URL`                                | MySQL 연결 URL            | `jdbc:mysql://localhost:3306/esg_database`  | Auth, TCFD, CSDD, GRI        |
| `DB_USERNAME`                           | MySQL 사용자명            | `esg_user`                                  | Auth, TCFD, CSDD, GRI        |
| `DB_PASSWORD`                           | MySQL 비밀번호            | `esg_password_123`                          | Auth, TCFD, CSDD, GRI        |
| `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE` | Eureka 서버 URL           | `http://localhost:8761/eureka/`             | 모든 서비스 (Discovery 제외) |
| `JWT_SECRET`                            | JWT 암호화 키 (32자 이상) | `mySecretKey123456789012345678901234567890` | Auth, Gateway                |

### 환경변수 설정 (.env 파일 권장)

```env
# 데이터베이스 설정
DB_URL=jdbc:mysql://localhost:3306/esg_database
DB_USERNAME=esg_user
DB_PASSWORD=esg_password_123

# Eureka 설정
EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://localhost:8761/eureka/

# JWT 설정 (32자 이상)
JWT_SECRET=mySecretKey123456789012345678901234567890

# AWS 설정 (Auth/TCFD Service용 - 선택적)
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
```

### MySQL 준비 (Docker 권장)

```yaml
# docker-compose.yml
version: "3.8"
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: esg_database
      MYSQL_USER: esg_user
      MYSQL_PASSWORD: esg_password_123
    ports:
      - "3306:3306"
    command: --default-authentication-plugin=mysql_native_password
```

## 서비스 실행 순서

올바른 실행 순서를 따라야 모든 서비스가 정상 작동합니다:

1. **MySQL 데이터베이스 시작**
2. **Discovery Service** (8761 포트)
3. **Gateway Service** (8080 포트)
4. **Auth Service** (8081 포트)
5. **TCFD Service** (8082 포트)
6. **CSDD Service** (8083 포트)
7. **GRI Service** (8084 포트)
8. **Dashboard Service** (8085 포트)

## 설정 검증

### 1. 환경변수 확인

**Windows:**

```cmd
echo %DB_URL%
echo %EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE%
```

**Linux/macOS:**

```bash
echo $DB_URL
echo $EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE
```

### 2. 데이터베이스 연결 테스트

```bash
mysql -h localhost -u esg_user -p esg_database
```

### 3. Eureka 서버 접속 확인

브라우저에서 `http://localhost:8761` 접속하여 Eureka 대시보드 확인

### 4. JWT 토큰 길이 확인

JWT_SECRET이 32자 이상인지 확인:

**Linux/macOS:**

```bash
echo $JWT_SECRET | wc -c
```

## 트러블슈팅

### 자주 발생하는 문제들

#### 1. 데이터베이스 연결 실패

- **증상**: 서비스 시작 시 데이터베이스 연결 오류
- **해결방법**:
  - MySQL 서버가 실행 중인지 확인
  - DB_URL, DB_USERNAME, DB_PASSWORD 값 재확인
  - 방화벽 설정 확인 (3306 포트)

#### 2. Eureka 등록 실패

- **증상**: 서비스가 Eureka에 등록되지 않음
- **해결방법**:
  - Discovery Service가 먼저 실행되었는지 확인
  - EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE 값 확인
  - 네트워크 연결 상태 확인

#### 3. JWT 인증 오류

- **증상**: API 호출 시 401 Unauthorized 오류
- **해결방법**:
  - Auth Service와 Gateway Service의 JWT_SECRET 값이 동일한지 확인
  - JWT_SECRET 길이가 32자 이상인지 확인
  - 토큰 만료 시간 확인 (기본 24시간)

#### 4. AWS S3 접근 오류

- **증상**: 파일 업로드/다운로드 실패
- **해결방법**:
  - AWS 자격증명 확인
  - S3 버킷 권한 설정 확인
  - 리전 설정 확인 (ap-northeast-2)

#### 5. 포트 충돌

- **증상**: 서비스 시작 시 포트 사용 중 오류
- **해결방법**:
  - 포트 사용 상태 확인: `netstat -an | grep :포트번호`
  - 사용 중인 프로세스 종료 또는 다른 포트 사용

### 로그 확인 방법

각 서비스의 로그를 확인하여 구체적인 오류 원인을 파악할 수 있습니다:

```bash
# Spring Boot 애플리케이션 로그 레벨 설정
logging.level.com.example=DEBUG
logging.level.org.springframework.web=DEBUG
```

## 보안 고려사항

### 프로덕션 환경

- **강력한 비밀번호 사용**: 데이터베이스 및 JWT 시크릿
- **환경변수 암호화**: Kubernetes Secrets, AWS Parameter Store 등 활용
- **네트워크 보안**: VPC, 보안 그룹, 방화벽 설정
- **SSL/TLS 사용**: 데이터베이스 연결 및 API 통신 암호화

### 개발 환경

- **.env 파일 보안**: `.gitignore`에 추가하여 버전 관리에서 제외
- **로컬 개발용 값 사용**: 프로덕션 값과 구분
- **정기적인 키 교체**: JWT 시크릿 및 AWS 액세스 키

이 가이드를 따라 환경변수를 올바르게 설정하면 ESG 프로젝트의 모든 서비스가 정상 작동합니다.
