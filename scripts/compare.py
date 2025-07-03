import re
import glob
import difflib

def parse_structs(content, filename=None, struct_files=None):
    structs = {}
    struct_re = re.compile(r'(?:typedef\s+)?struct\s+([A-Za-z0-9_]*)?\s*\{([^}]*)\}\s*([A-Za-z0-9_]+)?\s*;', re.DOTALL)
    field_re = re.compile(r'(?:__\w+\s+)?(?:volatile\s+)?(?:struct\s+)?[A-Za-z0-9_]+\s+([A-Za-z0-9_]+)')
    for m in struct_re.finditer(content):
        struct_name = m.group(3) or m.group(1)
        fields = []
        for line in m.group(2).splitlines():
            line = line.split('//')[0].strip()
            fm = field_re.match(line)
            if fm:
                fields.append(fm.group(1))
        if struct_name and fields:
            structs[struct_name] = fields
            if struct_files is not None and filename is not None:
                struct_files[struct_name] = filename
    return structs

def struct_name_similarity(a, b):
    # Remove common suffixes/prefixes for better matching
    def norm(s):
        return s.lower().replace('typedef', '').replace('struct_', '').replace('_t', '').replace('type', '')
    return difflib.SequenceMatcher(None, norm(a), norm(b)).ratio()

def subwords(name):
    return set(name.lower().replace('[','').replace(']','').split('_'))

def field_match_score(a, b):
    sa, sb = subwords(a), subwords(b)
    if sa & sb:
        return 1
    if a in b or b in a:
        return 1
    if difflib.SequenceMatcher(None, a, b).ratio() > 0.7:
        return 0.7
    return 0

def is_reserved(field):
    return any(x in field.lower() for x in ['reserved', 'rsv', 'rsvd'])

def filter_reserved(fields):
    return [f for f in fields if not is_reserved(f)]

def struct_match_score(fields_short, fields_long):
    # Filter reserved fields for matching
    fields_short = filter_reserved(fields_short)
    fields_long = filter_reserved(fields_long)
    matched = []
    unmatched = []
    used = set()
    for f in fields_short:
        best = None
        best_score = 0
        for i, g in enumerate(fields_long):
            if i in used:
                continue
            score = field_match_score(f, g)
            if score > best_score:
                best_score = score
                best = i
        if best_score >= 0.7:
            matched.append((f, fields_long[best]))
            used.add(best)
        else:
            unmatched.append(f)
    return matched, unmatched

def find_best_match(structs_a, structs_b):
    results = []
    for name_a, fields_a in structs_a.items():
        best_match = None
        best_matched = []
        best_unmatched = fields_a
        best_score = 0
        for name_b, fields_b in structs_b.items():
            if len(fields_a) <= len(fields_b):
                matched, unmatched = struct_match_score(fields_a, fields_b)
            else:
                matched, unmatched = struct_match_score(fields_b, fields_a)
            score = len(matched)
            if score > best_score:
                best_score = score
                best_match = name_b
                best_matched = matched
                best_unmatched = unmatched
        results.append((name_a, best_match, best_matched, best_unmatched))
    return results

def print_match_results(results, structs_b):
    for name_a, best_match, matched, unmatched in results:
        if best_match:
            print(f"\n{name_a} <-> {best_match}: {len(matched)} fields matched, {len(unmatched)} not matched")
            print(f"{'Matched fields':<30} | {'With':<30}")
            print("-"*62)
            for a, b in matched:
                print(f"{a:<30} | {b:<30}")
            if unmatched:
                print(f"\nUnmatched fields in {name_a}: {', '.join(unmatched)}")
            other_fields = set(structs_b[best_match])
            matched_b = set(b for _, b in matched)
            unmatched_b = other_fields - matched_b
            if unmatched_b:
                print(f"Unmatched fields in {best_match}: {', '.join(unmatched_b)}")
        else:
            print(f"\n{name_a}: No match found.")

def print_aligned_matches(matched, max_line=80, max_field=16):
    if not matched:
        return
    left_w = min(max((len(f1) for f1, _ in matched)), max_field)
    right_w = min(max((len(f2) for _, f2 in matched)), max_field)
    line = ""
    for f1, f2 in matched:
        f1s = f"{f1[:left_w]:<{left_w}}"
        f2s = f"{f2[:right_w]:<{right_w}}"
        pair = f"{f1s}:{f2s}, "
        if len(line) + len(pair) > max_line:
            print("    " + line.rstrip(", "))
            line = ""
        line += pair
    if line:
        print("    " + line.rstrip(", "))

# --- Main ---
phyplus_struct_files = {}
with open('./phy6252-SDK/components/inc/mcu_phy_bumbee.h', 'r', encoding='utf-8', errors='ignore') as f:
    phyplus_structs = parse_structs(f.read(), './phy6252-SDK/components/inc/mcu_phy_bumbee.h', phyplus_struct_files)

freq_struct_files = {}
freq_structs = {}
for path in glob.glob('./hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_*.h'):
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        freq_structs.update(parse_structs(f.read(), path, freq_struct_files))

# First pass: struct name similarity
name_threshold = 0.55  # Adjust as needed to catch all "obvious" matches
matched_a = set()
matched_b = set()
name_matches = []

for name_a in phyplus_structs:
    best = None
    best_score = 0
    for name_b in freq_structs:
        score = struct_name_similarity(name_a, name_b)
        if score > best_score:
            best_score = score
            best = name_b
    if best_score >= name_threshold:
        name_matches.append((name_a, best, best_score))
        matched_a.add(name_a)
        matched_b.add(best)

summary = []

print("=== Name-based matches ===")
for a, b, score in name_matches:
    fields_a = filter_reserved(phyplus_structs[a])
    fields_b = filter_reserved(freq_structs[b])
    if len(fields_a) <= len(fields_b):
        matched, unmatched = struct_match_score(fields_a, fields_b)
        total_fields = len(fields_a)
        shorter, longer = a, b
    else:
        matched, unmatched = struct_match_score(fields_b, fields_a)
        total_fields = len(fields_b)
        shorter, longer = b, a
    field_match_pct = len(matched) / total_fields if total_fields else 0
    struct_match_pct = struct_name_similarity(a, b)
    summary.append((shorter, longer, struct_match_pct, field_match_pct, total_fields))
    print(f"{a} <-> {b} (struct name match={struct_match_pct:.2f}, field match={field_match_pct:.2f})")
    if matched:
        print("  Matched:")
        print_aligned_matches(matched)
    if unmatched:
        print(f"  Unmatched in {a}: {', '.join(unmatched)}")
    other_fields = set(fields_b if len(fields_a) <= len(fields_b) else fields_a)
    matched_b = set(b for _, b in matched)
    unmatched_b = other_fields - matched_b
    if unmatched_b:
        print(f"  Unmatched in {b}: {', '.join(unmatched_b)}")
    print()

unmatched_a = [n for n in phyplus_structs if n not in matched_a]
unmatched_b = [n for n in freq_structs if n not in matched_b]

print("\n=== Unmatched struct names (PHYPLUS6252) ===")
for n in unmatched_a:
    print(n)
print("\n=== Unmatched struct names (FR801xH) ===")
for n in unmatched_b:
    print(n)

# Second pass: field-based matching for unmatched
print("\n=== Field-based matches for unmatched structs ===")
unmatched_structs_a = {n: phyplus_structs[n] for n in unmatched_a}
unmatched_structs_b = {n: freq_structs[n] for n in unmatched_b}
results = find_best_match(unmatched_structs_a, unmatched_structs_b)
print_match_results(results, unmatched_structs_b)

# Add field-based matches (second pass) to summary if not already present
for name_a, best_match, matched, unmatched in results:
    if best_match and len(matched) > 0:
        # Filter reserved fields for accurate total_fields
        fields_a = filter_reserved(unmatched_structs_a[name_a])
        fields_b = filter_reserved(unmatched_structs_b[best_match])
        if len(fields_a) <= len(fields_b):
            total_fields = len(fields_a)
            shorter, longer = name_a, best_match
        else:
            total_fields = len(fields_b)
            shorter, longer = best_match, name_a
        field_match_pct = len(matched) / total_fields if total_fields else 0
        struct_match_pct = struct_name_similarity(name_a, best_match)
        # Only add if not already in summary (by shorter/longer pair)
        if not any(s == shorter and l == longer for s, l, *_ in summary):
            summary.append((shorter, longer, struct_match_pct, field_match_pct, total_fields))

print("\n=== Updated summary of struct matches (with field-based matches) ===")
print(f"{'Shorter struct':<24} {'Longer struct':<24} {'Name %':>8} {'Field %':>8} {'Fields':>8} {'Sum %':>8}")
print("-"*90)
# Sort by (struct_match_pct + field_match_pct), descending
for shorter, longer, struct_match_pct, field_match_pct, total_fields in sorted(
        summary, key=lambda x: x[2] + x[3], reverse=True):
    sum_pct = struct_match_pct + field_match_pct
    print(f"{shorter:<24} {longer:<24} {struct_match_pct*100:7.1f}% {field_match_pct*100:7.1f}% {total_fields:8d} {sum_pct*100:7.1f}%")

print("\n=== Struct file locations ===")
for shorter, longer, *_ in summary:
    file_a = phyplus_struct_files.get(shorter) or freq_struct_files.get(shorter) or "?"
    file_b = phyplus_struct_files.get(longer) or freq_struct_files.get(longer) or "?"
    print(f"{shorter:<24} : {file_a}")
    print(f"{longer:<24} : {file_b}")
    print("-" * 60)
