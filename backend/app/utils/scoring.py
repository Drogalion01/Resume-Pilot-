def clamp_score(score: float, min_val: int = 0, max_val: int = 100) -> int:
    """Ensures the score stays strictly within 0-100 boundaries."""
    return int(max(min_val, min(score, max_val)))

def get_overall_label(score: int) -> str:
    """Returns frontend friendly assessment labels based on score tiers."""
    if score >= 85:
        return "Excellent"
    elif score >= 70:
        return "Good"
    elif score >= 50:
        return "Average"
    else:
        return "Poor"

def calculate_weighted_score(scores: dict, weights: dict) -> int:
    """
    Calculates a final score based on a scoring dictionary and a weights dictionary.
    Each individual score is assumed to be out of 100.
    """
    total_weight = sum(weights.values())
    if total_weight == 0:
        return 0
        
    weighted_sum = sum(scores.get(key, 0) * weight for key, weight in weights.items())
    return clamp_score(weighted_sum / total_weight)
