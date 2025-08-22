#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 색상 없음

# 로그 함수들
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 스크립트 시작
echo "=================================================="
echo "서브모듈 업데이트 프로세스를 시작합니다..."
echo "=================================================="

# 현재 Git 저장소인지 확인
if [ ! -d ".git" ]; then
    log_error "Git 저장소가 아닙니다!"
    exit 1
fi

# .gitmodules 파일이 있는지 확인
if [ ! -f ".gitmodules" ]; then
    log_error ".gitmodules 파일을 찾을 수 없습니다!"
    exit 1
fi

# 서브모듈 초기화 (처음 클론한 경우를 대비)
log_info "서브모듈을 초기화하는 중..."
git submodule init

# 현재 서브모듈 상태 체크
log_info "현재 서브모듈 상태:"
git submodule status

echo ""
log_info "모든 서브모듈을 최신 버전으로 업데이트하는 중..."

# 모든 서브모듈을 최신 버전으로 업데이트
if git submodule update --remote --merge; then
    log_success "모든 서브모듈이 성공적으로 업데이트되었습니다!"
else
    log_error "서브모듈 업데이트에 실패했습니다!"
    exit 1
fi

echo ""
log_info "업데이트된 서브모듈 상태:"
git submodule status

# 변경사항 확인
if git diff-index --quiet HEAD --; then
    log_warning "서브모듈에서 변경사항이 감지되지 않았습니다."
    echo "모든 서브모듈이 이미 최신 상태입니다!"
else
    echo ""
    log_info "변경사항이 감지되었습니다. 차이점 표시:"
    git diff --name-only
    
    echo ""
    log_info "변경사항을 자동으로 커밋하고 푸시합니다..."
    
    # 변경사항 스테이징
    log_info "변경사항을 스테이징하는 중..."
    git add .
    
    # 커밋 메시지 생성
    UPDATED_MODULES=$(git diff --cached --name-only | grep -E '^[^/]+$' | tr '\n' ', ' | sed 's/, $//')
    COMMIT_MSG="chore: update submodules to latest versions

Updated modules: $UPDATED_MODULES

update-all-submodules.sh에서 자동 생성된 커밋"
    
    # 커밋
    if git commit -m "$COMMIT_MSG"; then
        log_success "변경사항이 성공적으로 커밋되었습니다!"
        
        echo ""
        log_info "원격 저장소에 자동 푸시하는 중..."
        
        if git push; then
            log_success "변경사항이 원격 저장소에 성공적으로 푸시되었습니다!"
        else
            log_error "원격 저장소 푸시에 실패했습니다!"
            exit 1
        fi
    else
        log_error "변경사항 커밋에 실패했습니다!"
        exit 1
    fi
fi

echo ""
echo "=================================================="
echo "서브모듈 업데이트 프로세스가 완료되었습니다!"
echo "=================================================="

# 최종 상태 표시
echo ""
log_info "최종 서브모듈 상태:"
git submodule foreach 'echo "$name: $(git log --oneline -1)"'
