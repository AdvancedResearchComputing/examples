import json
import sys
import os
import re
import random

def generate_ids_with_error_handling(start_index, count):
    max_ids = 52  # Maximum IDs from A to ZA
    if start_index + count > max_ids:
        raise ValueError("ID generation exceeds the maximum allowed range of 'ZA'.")

    ids = []
    current_index = start_index

    while len(ids) < count:
        id = ""
        temp_index = current_index

        if temp_index < 26:  # A-Z
            id = chr(65 + temp_index)
        else:  # AA, BA, ..., ZA
            temp_index -= 26
            while temp_index >= 0:
                temp_index, remainder = divmod(temp_index, 26)
                id = chr(65 + remainder) + "A"
                temp_index -= 1

        ids.append(id)
        current_index += 1

    return ids

def parse_modifications(id_line, sequence_type):
    modifications = []
    matches = re.findall(r"&(\d+)_([A-Za-z]{3})", id_line)
    for match in matches:
        position = int(match[0])
        mod_type = match[1]

        if sequence_type == "protein":
            modifications.append({
                "ptmType": mod_type,
                "ptmPosition": position
            })
        elif sequence_type in {"dna", "rna"}:
            modifications.append({
                "modificationType": mod_type,
                "basePosition": position
            })
        elif sequence_type == "ligand":
            modifications.append({
                "modificationType": mod_type,
                "position": position
            })
    return modifications
    
def parse_bonded_atom_pairs(id_line, id_list):
    bonded_atom_pairs = []
    matches = re.findall(r"&(\d+)_([A-Za-z0-9]+)_(\d+)_([A-Za-z0-9]+)", id_line)

    for match in matches:
        atom1_position = int(match[0])
        atom1_type = match[1]
        atom2_position = int(match[2])
        atom2_type = match[3]

        for id_prefix in id_list:
            bonded_atom_pairs.append([
                [id_prefix, atom1_position, atom1_type],
                [id_prefix, atom2_position, atom2_type]
            ])

    return bonded_atom_pairs

def fasta_to_json(fasta_file):
    json_file = os.path.splitext(fasta_file)[0] + ".json"
    json_name = os.path.splitext(os.path.basename(fasta_file))[0]

    with open(fasta_file, "r") as file:
        lines = file.readlines()

    sequences = []
    current_name = None
    current_sequence = []
    last_id_end = 0
    bonded_atom_pairs = []

    for line in lines:
        line = line.strip()
        if line.startswith(">"):
            if current_name is not None:
                name_parts = current_name.split("#")
                name = name_parts[0]
                count = int(name_parts[1]) if len(name_parts) > 1 else 1
                id_list = generate_ids_with_error_handling(last_id_end, count)
                last_id_end += count

                sequence_type = "protein"
                if "dna" in current_name:
                    sequence_type = "dna"
                elif "rna" in current_name:
                    sequence_type = "rna"
                elif "ligand" in current_name:
                    sequence_type = "ligand"
                elif "smile" in current_name:
                    sequence_type = "smile"

                modifications = parse_modifications(current_name, sequence_type)

                if sequence_type in {"protein", "dna", "rna"}:
                    sequences.append({
                        sequence_type: {
                            "id": id_list,
                            "sequence": "".join(current_sequence).replace(" ", "").upper(),
                            "modifications": modifications
                        }
                    })
                elif sequence_type == "ligand":
                    ligand_sequence = "".join(current_sequence).replace(" ", "").upper()
                    if ',' in ligand_sequence:
                        ccdCodes = ligand_sequence.split(',')
                    else:
                        ccdCodes = [ligand_sequence]
                    bonded_atom_pairs.extend(parse_bonded_atom_pairs(current_name, id_list))
                    sequences.append({
                        "ligand": {
                            "id": id_list,
                            "ccdCodes": ccdCodes
                        }
                    })
                elif sequence_type == "smile":
                    sequences.append({
                        "ligand": {
                            "id": id_list,
                            "smiles": "".join(current_sequence).replace(" ", "")
                        }
                    })

            current_name = line[1:]
            current_sequence = []
        else:
            current_sequence.append(line)

    if current_name is not None:
        name_parts = current_name.split("#")
        name = name_parts[0]
        count = int(name_parts[1]) if len(name_parts) > 1 else 1
        id_list = generate_ids_with_error_handling(last_id_end, count)
        last_id_end += count

        sequence_type = "protein"
        if "dna" in current_name:
            sequence_type = "dna"
        elif "rna" in current_name:
            sequence_type = "rna"
        elif "ligand" in current_name:
            sequence_type = "ligand"
        elif "smile" in current_name:
            sequence_type = "smile"

        modifications = parse_modifications(current_name, sequence_type)

        if sequence_type in {"protein", "dna", "rna"}:
            sequences.append({
                sequence_type: {
                    "id": id_list,
                    "sequence": "".join(current_sequence).replace(" ", "").upper(),
                    "modifications": modifications
                }
            })
        elif sequence_type == "ligand":
            ligand_sequence = "".join(current_sequence).replace(" ", "").upper()
            if ',' in ligand_sequence:
                ccdCodes = ligand_sequence.split(',')
            else:
                ccdCodes = [ligand_sequence]
            bonded_atom_pairs.extend(parse_bonded_atom_pairs(current_name, id_list))
            sequences.append({
                "ligand": {
                    "id": id_list,
                    "ccdCodes": ccdCodes
                }
            })
        elif sequence_type == "smile":
            sequences.append({
                "ligand": {
                    "id": id_list,
                    "smiles": "".join(current_sequence).replace(" ", "")
                }
            })

    # Create random seed
    model_seeds = [random.randint(1, 100000)]

    data = {
        "name": json_name,
        "modelSeeds": model_seeds,
        "sequences": sequences,
        "bondedAtomPairs": bonded_atom_pairs,
        "dialect": "alphafold3",
        "version": 1
    }

    with open(json_file, "w") as json_out:
        json.dump(data, json_out, indent=2)
    print(f"\nConversion complete. JSON file saved as {json_file}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <fasta_file>")
        sys.exit(1)

    fasta_file = sys.argv[1]
    if not os.path.exists(fasta_file):
        print(f"Error: File '{fasta_file}' not found.")
        sys.exit(1)

    fasta_to_json(fasta_file)
    print(f"\nThis code was created by NC Ha at SNU.")