import React from "react";

import { Person } from "@/models/people";
import { Field } from "./FormState";

type SelectMultiPeopleField = Field<Person[]> & {
  type: "select-multi-people";
  setValue: React.Dispatch<React.SetStateAction<Person[]>>;
  options: Person[];
  alwaysSelected: Person[];
};

interface Config {
  optional?: boolean;
  alwaysSelected?: Person[];
  alreadySelected?: Person[];
}

export function useMultiPeopleSelectField(options: Person[], config?: Config): SelectMultiPeopleField {
  const alwaysSelected = config?.alwaysSelected ? [...config.alwaysSelected] : [];

  const [value, setValue] = React.useState<Person[]>(config?.alreadySelected || []);

  const validate = (): string | null => {
    if (value.length < 1) return !config?.optional ? "Can't be empty" : null;

    return null;
  };

  const reset = () => null;

  return {
    type: "select-multi-people",
    value,
    setValue,
    validate,
    options,
    optional: config?.optional,
    alwaysSelected,
    reset,
  };
}
