/**
 * SRS 알고리즘 테스트
 */

import {
  initializeCard,
  calculateNextReview,
  updateEaseFactor,
  calculateInterval,
  isDue,
  daysUntilDue,
  calculateAccuracy,
  getProgressStatus,
  type SRSData,
} from './algorithm';
import { AnswerQuality } from '@/components/flashcard/types';

describe('SRS Algorithm', () => {
  describe('initializeCard', () => {
    it('새 카드를 올바른 초기값으로 생성해야 함', () => {
      const card = initializeCard();

      expect(card.easeFactor).toBe(2.5);
      expect(card.interval).toBe(0);
      expect(card.repetitions).toBe(0);
      expect(card.totalReviews).toBe(0);
      expect(card.correctReviews).toBe(0);
      expect(card.lastReviewDate).toBeInstanceOf(Date);
      expect(card.nextReviewDate).toBeInstanceOf(Date);
    });
  });

  describe('updateEaseFactor', () => {
    it('Again(0) 답변 시 난이도 계수가 감소해야 함', () => {
      const newEF = updateEaseFactor(2.5, 0);
      expect(newEF).toBe(2.3); // 2.5 - 0.2
    });

    it('Hard(1) 답변 시 난이도 계수가 약간 감소해야 함', () => {
      const newEF = updateEaseFactor(2.5, 1);
      expect(newEF).toBe(2.35); // 2.5 - 0.15
    });

    it('Good(2) 답변 시 난이도 계수가 유지되어야 함', () => {
      const newEF = updateEaseFactor(2.5, 2);
      expect(newEF).toBe(2.5); // 2.5 + 0
    });

    it('Easy(3) 답변 시 난이도 계수가 증가해야 함', () => {
      const newEF = updateEaseFactor(2.5, 3);
      expect(newEF).toBe(2.65); // 2.5 + 0.15
    });

    it('난이도 계수가 최소값(1.3) 아래로 내려가지 않아야 함', () => {
      let ef = 1.4;
      // Again을 여러 번 반복
      for (let i = 0; i < 10; i++) {
        ef = updateEaseFactor(ef, 0);
      }
      expect(ef).toBeGreaterThanOrEqual(1.3);
    });

    it('난이도 계수가 최대값(3.5) 위로 올라가지 않아야 함', () => {
      let ef = 3.4;
      // Easy를 여러 번 반복
      for (let i = 0; i < 10; i++) {
        ef = updateEaseFactor(ef, 3);
      }
      expect(ef).toBeLessThanOrEqual(3.5);
    });
  });

  describe('calculateInterval', () => {
    it('첫 번째 성공(Good) 시 간격이 1일이어야 함', () => {
      const interval = calculateInterval(0, 0, 2.5, 2);
      expect(interval).toBe(1);
    });

    it('두 번째 성공(Good) 시 간격이 6일이어야 함', () => {
      const interval = calculateInterval(1, 1, 2.5, 2);
      expect(interval).toBe(6);
    });

    it('세 번째 이후 성공(Good) 시 간격이 EF만큼 증가해야 함', () => {
      const interval = calculateInterval(6, 2, 2.5, 2);
      expect(interval).toBe(15); // 6 * 2.5 = 15
    });

    it('Again(0) 답변 시 간격이 0으로 리셋되어야 함', () => {
      const interval = calculateInterval(15, 3, 2.5, 0);
      expect(interval).toBe(0);
    });

    it('Hard(1) 답변 시 간격이 짧게 설정되어야 함', () => {
      const interval = calculateInterval(10, 2, 2.5, 1);
      expect(interval).toBe(12); // 10 * 1.2 = 12
    });

    it('Easy(3) 답변 시 간격이 길게 설정되어야 함', () => {
      const interval = calculateInterval(6, 2, 2.5, 3);
      // 6 * 2.5 = 15, 15 * 1.3 = 19.5 -> 20
      expect(interval).toBe(20);
    });
  });

  describe('calculateNextReview', () => {
    let initialCard: SRSData;

    beforeEach(() => {
      initialCard = initializeCard();
    });

    it('Good 답변으로 첫 복습을 완료하면 1일 후 복습 예정', () => {
      const result = calculateNextReview(2, initialCard);

      expect(result.interval).toBe(1);
      expect(result.repetitions).toBe(1);
      expect(result.easeFactor).toBe(2.5);
      expect(result.reviewCount).toBe(1);
    });

    it('Again 답변 시 repetitions가 0으로 리셋', () => {
      const cardAfterSuccess = {
        ...initialCard,
        repetitions: 3,
        interval: 15,
      };

      const result = calculateNextReview(0, cardAfterSuccess);

      expect(result.interval).toBe(0);
      expect(result.repetitions).toBe(0);
      expect(result.easeFactor).toBe(2.3); // 2.5 - 0.2
    });

    it('Hard 답변 시 repetitions 유지', () => {
      const cardAfterSuccess = {
        ...initialCard,
        repetitions: 2,
        interval: 6,
      };

      const result = calculateNextReview(1, cardAfterSuccess);

      expect(result.repetitions).toBe(2); // 유지
      expect(result.easeFactor).toBe(2.35); // 2.5 - 0.15
    });

    it('Easy 답변 시 간격이 더 길어짐', () => {
      const cardAfterTwoSuccess = {
        ...initialCard,
        repetitions: 2,
        interval: 6,
        easeFactor: 2.5,
      };

      const result = calculateNextReview(3, cardAfterTwoSuccess);

      // 6 * 2.5 = 15, 15 * 1.3 = 19.5 -> 20
      expect(result.interval).toBe(20);
      expect(result.repetitions).toBe(3);
      expect(result.easeFactor).toBe(2.65); // 2.5 + 0.15
    });

    it('연속된 복습 시나리오 테스트', () => {
      let card = initialCard;

      // 첫 번째: Good
      let result = calculateNextReview(2, card);
      expect(result.interval).toBe(1);
      expect(result.repetitions).toBe(1);

      // 두 번째: Good
      card = {
        ...card,
        interval: result.interval,
        repetitions: result.repetitions,
        easeFactor: result.easeFactor,
      };
      result = calculateNextReview(2, card);
      expect(result.interval).toBe(6);
      expect(result.repetitions).toBe(2);

      // 세 번째: Good
      card = {
        ...card,
        interval: result.interval,
        repetitions: result.repetitions,
        easeFactor: result.easeFactor,
      };
      result = calculateNextReview(2, card);
      expect(result.interval).toBe(15); // 6 * 2.5
      expect(result.repetitions).toBe(3);

      // 네 번째: Easy
      card = {
        ...card,
        interval: result.interval,
        repetitions: result.repetitions,
        easeFactor: result.easeFactor,
      };
      result = calculateNextReview(3, card);
      expect(result.interval).toBe(51); // 15 * 2.65 * 1.3 = 51.675 -> 52
      expect(result.repetitions).toBe(4);
      expect(result.easeFactor).toBe(2.65); // 2.5 + 0.15
    });

    it('실패 후 재학습 시나리오', () => {
      let card = {
        ...initialCard,
        repetitions: 3,
        interval: 15,
        easeFactor: 2.5,
      };

      // 실패: Again
      let result = calculateNextReview(0, card);
      expect(result.interval).toBe(0);
      expect(result.repetitions).toBe(0);
      expect(result.easeFactor).toBe(2.3);

      // 재학습: Good
      card = {
        ...card,
        interval: result.interval,
        repetitions: result.repetitions,
        easeFactor: result.easeFactor,
      };
      result = calculateNextReview(2, card);
      expect(result.interval).toBe(1);
      expect(result.repetitions).toBe(1);
    });
  });

  describe('isDue', () => {
    it('복습 날짜가 지났으면 true 반환', () => {
      const pastDate = new Date('2025-01-01');
      const currentDate = new Date('2025-01-10');

      expect(isDue(pastDate, currentDate)).toBe(true);
    });

    it('복습 날짜가 오늘이면 true 반환', () => {
      const today = new Date('2025-01-10');
      const currentDate = new Date('2025-01-10');

      expect(isDue(today, currentDate)).toBe(true);
    });

    it('복습 날짜가 미래이면 false 반환', () => {
      const futureDate = new Date('2025-01-20');
      const currentDate = new Date('2025-01-10');

      expect(isDue(futureDate, currentDate)).toBe(false);
    });
  });

  describe('daysUntilDue', () => {
    it('복습까지 남은 일수를 정확히 계산', () => {
      const nextReview = new Date('2025-01-10');
      const currentDate = new Date('2025-01-05');

      expect(daysUntilDue(nextReview, currentDate)).toBe(5);
    });

    it('복습 날짜가 지났으면 음수 반환', () => {
      const nextReview = new Date('2025-01-10');
      const currentDate = new Date('2025-01-15');

      expect(daysUntilDue(nextReview, currentDate)).toBe(-5);
    });

    it('복습 날짜가 오늘이면 0 반환', () => {
      const today = new Date('2025-01-10');
      const currentDate = new Date('2025-01-10');

      expect(daysUntilDue(today, currentDate)).toBe(0);
    });
  });

  describe('calculateAccuracy', () => {
    it('정답률을 올바르게 계산', () => {
      expect(calculateAccuracy(80, 100)).toBe(0.8);
      expect(calculateAccuracy(50, 100)).toBe(0.5);
      expect(calculateAccuracy(100, 100)).toBe(1.0);
    });

    it('복습이 없으면 0 반환', () => {
      expect(calculateAccuracy(0, 0)).toBe(0);
    });
  });

  describe('getProgressStatus', () => {
    it('새 카드는 "new" 상태', () => {
      expect(getProgressStatus(0, 0)).toBe('new');
    });

    it('repetitions < 2는 "learning" 상태', () => {
      expect(getProgressStatus(0, 1)).toBe('learning');
      expect(getProgressStatus(1, 5)).toBe('learning');
    });

    it('2 <= repetitions < 5는 "reviewing" 상태', () => {
      expect(getProgressStatus(2, 10)).toBe('reviewing');
      expect(getProgressStatus(3, 15)).toBe('reviewing');
      expect(getProgressStatus(4, 20)).toBe('reviewing');
    });

    it('repetitions >= 5는 "mastered" 상태', () => {
      expect(getProgressStatus(5, 30)).toBe('mastered');
      expect(getProgressStatus(10, 50)).toBe('mastered');
    });
  });

  describe('실전 시나리오 통합 테스트', () => {
    it('완벽한 학습자: 모든 답을 Good으로 답변', () => {
      let card = initializeCard();
      const qualities: AnswerQuality[] = [2, 2, 2, 2, 2]; // Good만

      const intervals: number[] = [];
      const easFactors: number[] = [];

      qualities.forEach((quality) => {
        const result = calculateNextReview(quality, card);
        intervals.push(result.interval);
        easFactors.push(result.easeFactor);

        card = {
          ...card,
          interval: result.interval,
          repetitions: result.repetitions,
          easeFactor: result.easeFactor,
          totalReviews: result.reviewCount,
          correctReviews: quality >= 2 ? card.correctReviews + 1 : card.correctReviews,
        };
      });

      expect(intervals).toEqual([1, 6, 15, 38, 94]); // 대략적인 간격
      expect(easFactors.every((ef) => ef === 2.5)).toBe(true); // Good은 EF 유지
    });

    it('어려움을 겪는 학습자: Hard와 Good 섞임', () => {
      let card = initializeCard();
      const qualities: AnswerQuality[] = [1, 2, 1, 2, 2]; // Hard, Good 섞임

      qualities.forEach((quality) => {
        const result = calculateNextReview(quality, card);

        card = {
          ...card,
          interval: result.interval,
          repetitions: result.repetitions,
          easeFactor: result.easeFactor,
          totalReviews: result.reviewCount,
          correctReviews: quality >= 2 ? card.correctReviews + 1 : card.correctReviews,
        };
      });

      // Hard 답변으로 인해 EF가 감소했을 것
      expect(card.easeFactor).toBeLessThan(2.5);
      // 하지만 계속 학습 중
      expect(card.repetitions).toBeGreaterThan(0);
    });

    it('실패 후 회복하는 학습자', () => {
      let card = initializeCard();
      const qualities: AnswerQuality[] = [2, 2, 0, 2, 2]; // Good, Good, Again, Good, Good

      qualities.forEach((quality) => {
        const result = calculateNextReview(quality, card);

        card = {
          ...card,
          interval: result.interval,
          repetitions: result.repetitions,
          easeFactor: result.easeFactor,
          totalReviews: result.reviewCount,
          correctReviews: quality >= 2 ? card.correctReviews + 1 : card.correctReviews,
        };
      });

      // Again으로 인해 EF 감소
      expect(card.easeFactor).toBeLessThan(2.5);
      // 하지만 다시 학습 중
      expect(card.repetitions).toBeGreaterThan(0);
      // 정답률 80% (4/5)
      expect(calculateAccuracy(card.correctReviews, card.totalReviews)).toBe(0.8);
    });

    it('마스터 학습자: 모든 답을 Easy로 답변', () => {
      let card = initializeCard();
      const qualities: AnswerQuality[] = [3, 3, 3, 3, 3]; // Easy만

      qualities.forEach((quality) => {
        const result = calculateNextReview(quality, card);

        card = {
          ...card,
          interval: result.interval,
          repetitions: result.repetitions,
          easeFactor: result.easeFactor,
          totalReviews: result.reviewCount,
          correctReviews: quality >= 2 ? card.correctReviews + 1 : card.correctReviews,
        };
      });

      // Easy 답변으로 인해 EF 증가
      expect(card.easeFactor).toBeGreaterThan(2.5);
      // 간격도 매우 길어짐
      expect(card.interval).toBeGreaterThan(50);
      // 마스터 상태
      expect(getProgressStatus(card.repetitions, card.totalReviews)).toBe('mastered');
    });
  });
});
